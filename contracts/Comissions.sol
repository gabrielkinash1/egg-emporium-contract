// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

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

    uint256 public mintPrice = 350 ether;

    address payable public payableAddress = payable(0xB458C783f1DFCd9063003552fD4A3Fe90F45b56c);

    address[] private giveawayAddresses;

    string private _defaultBaseURI;

    constructor() ERC721("EE Comissions", "EEC") {}

    modifier whenCallerCanGiveaway() {
        if (owner() == _msgSender()) {
            _;
        } else {
            for (uint256 i = 0; i < giveawayAddresses.length; i++) {
                if (giveawayAddresses[i] == _msgSender() && giveawayAddresses[i] != address(0)) {
                    _;
                }
            }
        }
    }

    function mint(uint256 quantity) external payable whenNotPaused {
        uint256 totalPrice = mintPrice * quantity;
        require(msg.value >= totalPrice, "Invalid amount!");

        payableAddress.transfer(totalPrice);
        
        uint256 tokenId = _tokenIds.current();
        for (uint256 i = 0; i < quantity; i++) {
            internalMint(msg.sender, tokenId + i);
        }
    }

    function giveaway(uint256 quantity) external payable whenCallerCanGiveaway {
        uint256 tokenId = _tokenIds.current();
        for (uint256 i = 0; i < quantity; i++) {
            internalMint(msg.sender, tokenId + i);
        }
    }

    function internalMint(address to, uint256 tokenId) internal {
        _safeMint(to, tokenId);
        _tokenIds.increment();
    }

    function addGiveawayPower(address authorizedAddress) public onlyOwner {
        giveawayAddresses.push(authorizedAddress);
    }

    function setPayableAddress(address newPayableAddress) public onlyOwner {
        payableAddress = payable(newPayableAddress);
    }

    function setMintPrice(uint256 newMintPrice) public onlyOwner {
        mintPrice = newMintPrice;
    }

    function setBaseURI(string calldata newBaseURI) public onlyOwner {
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