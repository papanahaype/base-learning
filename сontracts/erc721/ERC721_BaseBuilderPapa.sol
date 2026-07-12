// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BaseBuilderPapa is ERC721, Ownable {
    uint256 public nextTokenId;

    constructor()
        ERC721("Base Builder Papa", "BBP")
        Ownable(msg.sender)
    {}

    function mint(address to) external onlyOwner {
        uint256 tokenId = nextTokenId;
        nextTokenId++;

        _safeMint(to, tokenId);
    }
}