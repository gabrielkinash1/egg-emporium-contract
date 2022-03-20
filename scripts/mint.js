const hre = require("hardhat");
const Comissions = require("../artifacts/contracts/Comissions.sol/Comissions.json");

const contractAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";

async function main() {
  const accounts = await hre.ethers.getSigners();
  const contract = new hre.ethers.Contract(
    contractAddress,
    Comissions.abi,
    accounts[1]
  );

  const price = hre.ethers.utils.parseUnits(String(350 * 1), 18);

  const tx = await contract.mint(1, { value: price });
  await tx.wait();

  if (tx) {
    console.log("Mint!");
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
