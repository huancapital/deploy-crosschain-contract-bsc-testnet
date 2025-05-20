import { ethers, run } from "hardhat";

async function main() {
  console.log("Starting CrossChainBridge deployment...");
  console.log("Current time", new Date().toISOString());

  // Get the deployer signer
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);
  
  // Get account balance
  const balance = await ethers.provider.getBalance(deployer.address);
  console.log("Account balance:", ethers.formatEther(balance), "BNB");

  // Get the contract factory with the deployer signer
  const CrossChainBridge = await ethers.getContractFactory("CrossChainBridge", deployer);
  console.log("CrossChainBridge contract factory created");

  // Deployment parameters
  const feePercentage = 30; // 0.3% in basis points
  const minFee = ethers.parseEther("0.0001"); // 0.0001 BNB minimum fee

  console.log("Deployment parameters:");
  console.log("Fee Percentage:", feePercentage, "basis points (0.3%)");
  console.log("Minimum Fee:", ethers.formatEther(minFee), "BNB");

  // Deploy the contract
  console.log("Deploying CrossChainBridge...");
  const bridge = await CrossChainBridge.deploy(feePercentage, minFee);

  // Wait for deployment to finish
  await bridge.waitForDeployment();

  const address = await bridge.getAddress();
  console.log("CrossChainBridge deployed to:", address);

  // Wait for a few block confirmations
  console.log("Waiting for block confirmations...");
  const deployTx = bridge.deploymentTransaction();
  if (deployTx) {
    await deployTx.wait(5);
    console.log("Transaction confirmed!");
  }

  // Verify the contract on the network's block explorer
  if (process.env.VERIFY_CONTRACT === "true") {
    console.log("Verifying contract...");
    try {
      await run("verify:verify", {
        address: address,
        constructorArguments: [feePercentage, minFee],
      });
      console.log("Contract verified successfully");
    } catch (error) {
      console.log("Contract verification failed:", error);
    }
  }

  console.log("Deployment completed!");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
}); 