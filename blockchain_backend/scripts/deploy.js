const hre = require("hardhat");

async function main() {
  const HealthRecord = await hre.ethers.getContractFactory("HealthRecord");
  console.log("Deploying HealthRecord contract...");
  const healthRecord = await HealthRecord.deploy();
  await healthRecord.deployed();
  console.log("HealthRecord contract deployed to:", healthRecord.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });