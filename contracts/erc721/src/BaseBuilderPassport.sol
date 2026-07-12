// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract BaseBuilderPassport is ERC721, Ownable {
    uint256 private _nextTokenId;
    string private _baseTokenURI;

    constructor(
        address initialOwner
    )
        ERC721("Base Builder Passport", "BBP")
        Ownable(initialOwner)
    {}

    function safeMint(address to) public onlyOwner {
        _safeMint(to, _nextTokenId);
        _nextTokenId++;
    }

    function setBaseURI(string memory newBaseURI) public onlyOwner {
        _baseTokenURI = newBaseURI;
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    function nextTokenId() public view returns (uint256) {
        return _nextTokenId;
    }
}