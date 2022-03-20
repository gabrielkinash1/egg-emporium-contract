// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Comissions is ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Pausable, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;
    
    Counters.Counter private _tokenIds;

    Counters.Counter private _mintCount;

    Counters.Counter private _giveawayCount;

    uint256 public maxTokens = maxMintable + maxGiveaway;
    
    uint256 public maxMintable = 50;

    uint256 public maxGiveaway = 10;

    uint256 public mintPrice = 350 ether;

    address payable public payableAddress = payable(0xB458C783f1DFCd9063003552fD4A3Fe90F45b56c);

    string private _defaultBaseURI;

    constructor() ERC721("EE Comissions", "EEC") {
        console.log("Egg Emporium Comissions contract deployed!");
        _tokenIds.increment();
    }

    function mint(uint256 quantity) external payable whenNotPaused {
        uint256 amountMint = _mintCount.current();
        require(amountMint < maxMintable && (amountMint + quantity) < maxMintable, "Mint limit exceeded!");
        
        uint256 totalPrice = mintPrice * quantity;
        require(msg.value >= totalPrice, "Invalid amount!");

        payableAddress.transfer(totalPrice);
        
        uint256 tokenId = _tokenIds.current();
        for (uint256 i = 0; i < quantity; i++) {
            mintNFT(msg.sender, tokenId + 1);
        }
    }

    function giveaway(uint256 quantity) external payable onlyOwner {
        uint256 amountGiveaway = _giveawayCount.current();
        require(amountGiveaway < maxGiveaway && (amountGiveaway + quantity) < maxGiveaway, "Mint limit exceeded!");
        
        uint256 tokenId = _tokenIds.current();
        for (uint256 i = 0; i < quantity; i++) {
            giveNFT(msg.sender, tokenId + 1);
        }
    }

    function mintNFT(address to, uint256 tokenId) internal {
        internalMint(to, tokenId);
        _mintCount.increment();
    }

    function giveNFT(address to, uint256 tokenId) internal {
        internalMint(to, tokenId);
        _giveawayCount.increment();
    }

    function internalMint(address to, uint256 tokenId) internal {
        require(tokenId <= maxTokens, "Token limit exceeded!");
        _safeMint(to, tokenId);
        _tokenIds.increment();
    }

    function setPayableAddress(address newPayableAddress) public onlyOwner {
        payableAddress = payable(newPayableAddress);
    }

    function setMintPrice(uint256 newMintPrice) public onlyOwner {
        mintPrice = newMintPrice;
    }

    function setMaxMintable(uint256 newMaxMintable) public onlyOwner {
        maxMintable = newMaxMintable;
    }

    function setMaxGiveaway(uint256 newMaxGiveaway) public onlyOwner {
        maxGiveaway = newMaxGiveaway;
    }

    function setBaseURI(string calldata newBaseURI) public onlyOwner {
        console.log("Base URI changed from '%s' to '%s'", _defaultBaseURI, newBaseURI);
        _defaultBaseURI = newBaseURI;
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"));
    }

    function _baseURI() internal view override returns (string memory) {
        return _defaultBaseURI;
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable, ERC721Pausable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}