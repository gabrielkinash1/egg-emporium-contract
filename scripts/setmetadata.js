require("dotenv").config();
const hre = require("hardhat");
const Comissions = require("../artifacts/contracts/Comissions.sol/Comissions.json");

const contractAddress = process.env.CONTRACT_ADDRESS;

const metadata =
  "https://ipfs.io/ipfs/QmeRBhKGdugtUjDVJudsh7PMbFaAQyej48iTSmfgKu9JJE";

async function main() {
  const accounts = await hre.ethers.getSigners();
  const contract = new hre.ethers.Contract(
    contractAddress,
    Comissions.abi,
    accounts[0]
  );

  const tx = contract.setTokenURI(1, metadata);
  await tx.wait();

  if (tx) {
    console.log("Metadata changed!");
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
