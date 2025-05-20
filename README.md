![image](https://github.com/user-attachments/assets/ad6fd554-71ec-498c-9814-23cfdefd208c)

# BNW Token (BNWT)

This repository contains the smart contract and deployment scripts for the BNW Token (BNWT), an ERC20 token deployed on the BNW network.

## Contract Details

- **Token Name**: BNW Token
- **Token Symbol**: BNWT
- **Total Supply**: 1,000,000,000 BNWT
- **Decimals**: 18
- **Network**: BNW Network (Chain ID: 714)
- **Latest Contract Address**: `0x83257E0d7013Aa3fA1CE328eC5566e51780702BE`

## Features

- Standard ERC20 token implementation
- Minting capability (owner only)
- Burning capability (any token holder)
- OpenZeppelin contracts integration
- Comprehensive test suite
- Gas optimization
- Contract verification support

## Prerequisites

- Node.js (v16 or later)
- Yarn package manager
- A wallet with BNW for deployment gas fees

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd bnw-tokens
```

2. Install dependencies:
```bash
yarn install
```

## Deployment

To deploy the token to the BNW network:

1. Make sure you have enough BNW in your wallet for deployment gas fees
2. Run the deployment script:
```bash
yarn hardhat run scripts/deploy.ts --network bnw
```

The script will:
- Deploy the BNWT token contract
- Set the initial supply to 1 billion tokens
- Wait for transaction confirmations
- Output the contract address and deployment details

## Development

### Compile Contracts
```bash
yarn hardhat compile
```

### Run Tests
```bash
yarn hardhat test
```

### Network Configuration
The project is configured to deploy to the BNW network with the following settings:
- RPC URL: http://174.138.18.77:8545
- Chain ID: 714

## Contract Verification

To verify the contract on the block explorer (if supported), set the environment variable:
```bash
export VERIFY_CONTRACT=true
```

Then run the deployment script as usual.

## Contract Details

### BNWToken.sol
- **Name**: BNW Token
- **Symbol**: BNW
- **Decimals**: 18
- **Initial Supply**: 1,000,000,000 BNW

### Functions
- `transfer(address to, uint256 amount)`: Transfer tokens to another address
- `mint(address to, uint256 amount)`: Mint new tokens (owner only)
- `burn(uint256 amount)`: Burn tokens from your balance

## Testing

The test suite includes:
- Deployment tests
- Transfer functionality
- Minting permissions
- Burning functionality
- Error cases

Run the test suite with:
```bash
yarn hardhat test
```

## Gas Optimization

The contract is optimized for gas efficiency:
- Uses OpenZeppelin's optimized contracts
- Implements Solidity 0.8.20
- Uses the optimizer with 200 runs
- Implements viaIR for better optimization

## Security

- Uses OpenZeppelin's audited contracts
- Implements standard security patterns
- Includes comprehensive test coverage
- Uses SafeMath (built into Solidity 0.8.x)

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request
