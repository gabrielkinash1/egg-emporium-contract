const hre = require("hardhat");

async function main() {
  const Comissions = await hre.ethers.getContractFactory("Comissions");
  const comissions = await Comissions.deploy();
  await comissions.deployed();

  console.log("Comissions deployed to:", comissions.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
