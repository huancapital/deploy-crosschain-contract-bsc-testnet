# Cross-Chain Contract Deployment on BSC Testnet

This project demonstrates the deployment of smart contracts on the Binance Smart Chain (BSC) testnet.

## Prerequisites

- Node.js (v14 or higher)
- npm or yarn
- MetaMask wallet with BSC testnet configured
- BSC testnet BNB for gas fees

## BSC Testnet Configuration

### Network Details
- Network Name: BSC Testnet
- RPC URL: https://data-seed-prebsc-1-s1.binance.org:8545/
- Chain ID: 97
- Currency Symbol: tBNB
- Block Explorer: https://testnet.bscscan.com

### Adding BSC Testnet to MetaMask
1. Open MetaMask
2. Click on the network dropdown
3. Select "Add Network"
4. Enter the network details above
5. Click "Save"

## Getting Started

1. Clone the repository:
```bash
git clone <repository-url>
cd deploy-crosschain-contract-bsc-testnet
```

2. Install dependencies:
```bash
npm install
# or
yarn install
```

3. Create a `.env` file in the root directory and add your private key:
```
PRIVATE_KEY=your_private_key_here
```

⚠️ **Important**: Never commit your private key to version control. The `.env` file should be in your `.gitignore`.

## Deployment

To deploy the contract to BSC testnet:

```bash
npx hardhat run scripts/deploy.js --network bscTestnet
```

## Contract Verification

After deployment, verify your contract on BSCScan:

```bash
npx hardhat verify --network bscTestnet <deployed-contract-address> <constructor-arguments>
```

## Testing

Run the test suite:

```bash
npx hardhat test
```

## Project Structure

```
├── contracts/          # Smart contract source files
├── scripts/           # Deployment and interaction scripts
├── test/             # Test files
├── hardhat.config.js # Hardhat configuration
└── .env              # Environment variables (not tracked in git)
```

## Security

- Always use a dedicated wallet for testing
- Never share your private keys
- Use environment variables for sensitive data
- Test thoroughly before deploying to mainnet

## License

MIT

## Support

For support, please open an issue in the repository.
