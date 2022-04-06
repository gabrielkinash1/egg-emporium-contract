const { expect } = require("chai");
const { BigNumber } = require("ethers");
const { ethers } = require("hardhat");
const {
  abi,
} = require("../artifacts/contracts/IndonesianEggs.sol/IndonesianEggs.json");

describe("IndonesianEggs", function () {
  it("Change token URI", async function () {
    const IndonesianEggs = await ethers.getContractFactory("IndonesianEggs");
    const indonesianEggs = await IndonesianEggs.deploy();
    await indonesianEggs.deployed();

    const accounts = await ethers.getSigners();

    expect(await indonesianEggs.tokenURI(1)).to.equal("");

    const txn = await indonesianEggs.setTokenURI(1, "abcdefg");
    await txn.wait();

    const mint = await indonesianEggs.give(accounts[0].address, 1);
    await mint.wait();

    expect(await indonesianEggs.tokenURI(1)).to.equal("abcdefg");
  });
});
