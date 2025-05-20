// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title CrossChainBridge
 * @dev Contract for facilitating cross-chain token transfers
 */
contract CrossChainBridge {
    address public owner;
    uint256 public feePercentage; // Fee in basis points (1/100 of 1%)
    uint256 public minFee; // Minimum fee amount in wei
    mapping(bytes32 => bool) public processedTransfers;
    mapping(address => uint256) public liquidityProviders;
    uint256 public totalLiquidity;
    
    // Events
    event LiquidityAdded(address indexed provider, uint256 amount);
    event LiquidityRemoved(address indexed provider, uint256 amount);
    event TransferInitiated(
        bytes32 indexed transferId,
        address indexed sender,
        address indexed receiver,
        uint256 amount,
        uint256 fee,
        uint256 sourceChainId,
        uint256 destinationChainId
    );
    event TransferCompleted(
        bytes32 indexed transferId,
        address indexed receiver,
        uint256 amount
    );
    
    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    // Constructor
    constructor(uint256 _feePercentage, uint256 _minFee) {
        owner = msg.sender;
        feePercentage = _feePercentage; // Default: 30 (0.3%)
        minFee = _minFee; // Default: 0.0001 ether (in wei)
    }
    
    // Functions
    
    /**
     * @dev Add liquidity to the bridge
     */
    function addLiquidity() external payable {
        require(msg.value > 0, "Amount must be greater than 0");
        
        liquidityProviders[msg.sender] += msg.value;
        totalLiquidity += msg.value;
        
        emit LiquidityAdded(msg.sender, msg.value);
    }
    
    /**
     * @dev Remove liquidity from the bridge
     * @param amount Amount of liquidity to remove
     */
    function removeLiquidity(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(liquidityProviders[msg.sender] >= amount, "Insufficient liquidity");
        
        liquidityProviders[msg.sender] -= amount;
        totalLiquidity -= amount;
        
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
        
        emit LiquidityRemoved(msg.sender, amount);
    }
    
    /**
     * @dev Calculate fee for a transfer
     * @param amount Amount to calculate fee for
     * @return Fee amount
     */
    function calculateFee(uint256 amount) public view returns (uint256) {
        uint256 fee = (amount * feePercentage) / 10000;
        return fee < minFee ? minFee : fee;
    }
    
    /**
     * @dev Initiate a cross-chain transfer
     * @param receiver Receiver address on the destination chain
     * @param destinationChainId Destination chain ID
     */
    function initiateTransfer(
        address receiver,
        uint256 destinationChainId
    ) external payable {
        require(msg.value > 0, "Amount must be greater than 0");
        require(destinationChainId != block.chainid, "Cannot transfer to same chain");
        
        uint256 amount = msg.value;
        uint256 fee = calculateFee(amount);
        uint256 transferAmount = amount - fee;
        
        require(transferAmount > 0, "Amount after fee must be greater than 0");
        
        // Generate transfer ID
        bytes32 transferId = keccak256(
            abi.encodePacked(
                msg.sender,
                receiver,
                transferAmount,
                block.chainid,
                destinationChainId,
                block.timestamp
            )
        );
        
        // Mark transfer as processed on this chain
        processedTransfers[transferId] = true;
        
        // Emit event for off-chain relayer
        emit TransferInitiated(
            transferId,
            msg.sender,
            receiver,
            transferAmount,
            fee,
            block.chainid,
            destinationChainId
        );
    }
    
    /**
     * @dev Complete a cross-chain transfer (called by relayer)
     * @param transferId Transfer ID
     * @param receiver Receiver address
     * @param amount Amount to transfer
     */
    function completeTransfer(
        bytes32 transferId,
        address receiver,
        uint256 amount
    ) external onlyOwner {
        require(!processedTransfers[transferId], "Transfer already processed");
        require(totalLiquidity >= amount, "Insufficient liquidity");
        
        // Mark transfer as processed
        processedTransfers[transferId] = true;
        
        // Transfer funds
        (bool success, ) = payable(receiver).call{value: amount}("");
        require(success, "Transfer failed");
        
        emit TransferCompleted(transferId, receiver, amount);
    }
    
    /**
     * @dev Update fee percentage
     * @param _feePercentage New fee percentage (in basis points)
     */
    function updateFeePercentage(uint256 _feePercentage) external onlyOwner {
        feePercentage = _feePercentage;
    }
    
    /**
     * @dev Update minimum fee
     * @param _minFee New minimum fee
     */
    function updateMinFee(uint256 _minFee) external onlyOwner {
        minFee = _minFee;
    }
    
    /**
     * @dev Get liquidity provider's balance
     * @param provider Provider address
     * @return Provider's liquidity balance
     */
    function getProviderLiquidity(address provider) external view returns (uint256) {
        return liquidityProviders[provider];
    }
    
    /**
     * @dev Update owner
     * @param newOwner New owner address
     */
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid address");
        owner = newOwner;
    }
    
    /**
     * @dev Withdraw fees (only owner)
     * @param amount Amount to withdraw
     */
    function withdrawFees(uint256 amount) external onlyOwner {
        require(amount <= address(this).balance - totalLiquidity, "Cannot withdraw liquidity");
        
        (bool success, ) = payable(owner).call{value: amount}("");
        require(success, "Transfer failed");
    }
    
    /**
     * @dev Reset transfer status (for testing purposes only)
     * @param transferId Transfer ID to reset
     */
    function resetTransferStatus(bytes32 transferId) external onlyOwner {
        processedTransfers[transferId] = false;
    }
    
    // Allow contract to receive ETH
    receive() external payable {}
}