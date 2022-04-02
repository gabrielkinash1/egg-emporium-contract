require("dotenv").config();
const hre = require("hardhat");
const Comissions = require("../artifacts/contracts/Comissions_flat.sol/Comissions.json");

const contractAddress = process.env.CONTRACT_ADDRESS;

async function main() {
  const accounts = await hre.ethers.getSigners();
  const contract = new hre.ethers.Contract(
    contractAddress,
    Comissions.abi,
    accounts[0]
  );

  const tx = await contract.transferFrom(
    accounts[0].address,
    "0x0000000000000000000000000000000000000000",
    0
  );
  await tx.wait();
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
