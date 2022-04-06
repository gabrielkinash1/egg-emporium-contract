//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract IndonesianEggs is ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Pausable, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;

    Counters.Counter private _mintCount;

    Counters.Counter private _giveawayCount;

    mapping(uint256 => string) private _tokenURIs;

    mapping(uint256 => bool) private mintAvailable;

    string private _defaultBaseURI;

    uint256 public maxTokens = 60;

    uint256 public maxMintable = 50;

    uint256 public maxGiveaway = 10;

    uint256 public mintPrice = 200 ether;

    address payable public payableAddress;

    constructor() ERC721("EE Traditional Living", "EETL") {
        for (uint256 i = 1; i <= maxTokens; i++) {
            mintAvailable[i] = true;
        }
    }

    function mint(uint256 tokenId) external payable whenNotPaused {
        require(mintAvailable[tokenId], "Token already minted");
        
        uint256 alreadyMinted = _mintCount.current();
        require(alreadyMinted < maxMintable, "Mint limit reached");
        require(msg.value >= mintPrice, "Invalid price");

        payableAddress.transfer(mintPrice);
        mintNFT(msg.sender, tokenId);
    }

    function give(address to, uint256 tokenId) external onlyOwner {
        require(mintAvailable[tokenId], "Token already minted");

        uint256 alreadyGave = _giveawayCount.current();
        require(alreadyGave < maxGiveaway, "Giveaway limit reached");

        giveNFT(to, tokenId);
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
        require(tokenId <= maxTokens, "Token limit exceeded");
        _safeMint(to, tokenId);
        mintAvailable[tokenId] = false;
    }

    function burn(uint256 tokenId) public {
        require(ownerOf(tokenId) == msg.sender || msg.sender == owner() && owner() != address(0), "Address cannot burn this token");
        _burn(tokenId);
    }

    function togglePause() external onlyOwner {
        if (paused()) {
            _unpause();
        } else {
            _pause();
        }
    }

    function setMaxTokens(uint256 newMaxTokens) external onlyOwner {
        maxTokens = newMaxTokens;
    }

    function setMaxMintable(uint256 newMaxMintable) external onlyOwner {
        maxMintable = newMaxMintable;
    }

    function setMaxGiveaway(uint256 newMaxGiveaway) external onlyOwner {
        maxGiveaway = newMaxGiveaway;
    }

    function setPayableAddress(address newPayableAddress) public onlyOwner {
        payableAddress = payable(newPayableAddress);
    }

    function setMintPrice(uint256 newMintPrice) public onlyOwner {
        mintPrice = newMintPrice;
    }

    function setTokenURI(uint256 tokenId, string calldata newURI) public onlyOwner {
        _tokenURIs[tokenId] = newURI;
    }

    function setBaseURI(string calldata newURI) public onlyOwner {
        _defaultBaseURI = newURI;
    }

    function makeAvailable(uint256 tokenId) public onlyOwner {
        mintAvailable[tokenId] = true;
    }

    function makeAvailables(uint256[] calldata tokenIds) public onlyOwner {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            mintAvailable[tokenIds[i]] = true;
        }
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        if (mintAvailable[tokenId]) {
            return _baseURI();
        }
        
        return _tokenURIs[tokenId];
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