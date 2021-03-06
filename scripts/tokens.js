require("dotenv").config();
const hre = require("hardhat");
const Comissions = require("../artifacts/contracts/Comissions.sol/Comissions.json");

const contractAddress = process.env.CONTRACT_ADDRESS;

async function main() {
  const accounts = await hre.ethers.getSigners();
  const contract = new hre.ethers.Contract(
    contractAddress,
    Comissions.abi,
    accounts[1]
  );

  const tokens = [];
  const balance = await contract.balanceOf(accounts[1].address);
  for (let i = 0; i < balance; i++) {
    tokens.push(await contract.tokenOfOwnerByIndex(accounts[1].address, i));
  }

  console.log(tokens);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
