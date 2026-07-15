// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BaseBuilderPapa1155 is ERC1155, Ownable {
    uint256 public constant BUILDER_BADGE = 1;
    uint256 public constant EARLY_SUPPORTER = 2;
    uint256 public constant BASE_EXPLORER = 3;

    constructor()
        ERC1155("https://example.com/metadata/{id}.json")
        Ownable(msg.sender)
    {}

    function mint(
        address to,
        uint256 id,
        uint256 amount
    ) external onlyOwner {
        _mint(to, id, amount, "");
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts
    ) external onlyOwner {
        _mintBatch(to, ids, amounts, "");
    }

    function setURI(string memory newURI) external onlyOwner {
        _setURI(newURI);
    }
}