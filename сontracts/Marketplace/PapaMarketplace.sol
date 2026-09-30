// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PapaMarketplace is ReentrancyGuard, Ownable {

    struct Listing {
        address seller;
        uint256 price;
    }

    // NFT contract => tokenId => listing
    mapping(address => mapping(uint256 => Listing)) public listings;

    uint256 public marketplaceFee = 250; // 2.5%
    uint256 public constant FEE_DENOMINATOR = 10_000;

    event NFTListed(
        address indexed nftContract,
        uint256 indexed tokenId,
        address indexed seller,
        uint256 price
    );

    event ListingUpdated(
        address indexed nftContract,
        uint256 indexed tokenId,
        uint256 newPrice
    );

    event ListingCancelled(
        address indexed nftContract,
        uint256 indexed tokenId,
        address indexed seller
    );

    event NFTSold(
        address indexed nftContract,
        uint256 indexed tokenId,
        address indexed seller,
        address buyer,
        uint256 price
    );

    constructor() Ownable(msg.sender) {}

    function listNFT(
        address nftContract,
        uint256 tokenId,
        uint256 price
    ) external {
        require(nftContract != address(0), "Invalid NFT contract");
        require(price > 0, "Price must be greater than zero");

        IERC721 nft = IERC721(nftContract);

        require(nft.ownerOf(tokenId) == msg.sender, "Not NFT owner");

        require(
            nft.getApproved(tokenId) == address(this) ||
            nft.isApprovedForAll(msg.sender, address(this)),
            "Marketplace not approved"
        );

        require(
            listings[nftContract][tokenId].seller == address(0),
            "Already listed"
        );

        listings[nftContract][tokenId] = Listing({
            seller: msg.sender,
            price: price
        });

        emit NFTListed(nftContract, tokenId, msg.sender, price);
    }

    function updateListing(
        address nftContract,
        uint256 tokenId,
        uint256 newPrice
    ) external {
        Listing storage listing = listings[nftContract][tokenId];

        require(listing.seller == msg.sender, "Not seller");
        require(newPrice > 0, "Price must be greater than zero");

        listing.price = newPrice;

        emit ListingUpdated(nftContract, tokenId, newPrice);
    }

    function cancelListing(
        address nftContract,
        uint256 tokenId
    ) external {
        Listing memory listing = listings[nftContract][tokenId];

        require(listing.seller == msg.sender, "Not seller");

        delete listings[nftContract][tokenId];

        emit ListingCancelled(nftContract, tokenId, msg.sender);
    }

    function buyNFT(
        address nftContract,
        uint256 tokenId
    ) external payable nonReentrant {
        Listing memory listing = listings[nftContract][tokenId];

        require(listing.seller != address(0), "Not listed");
        require(msg.sender != listing.seller, "Seller cannot buy own NFT");
        require(msg.value == listing.price, "Incorrect ETH amount");

        IERC721 nft = IERC721(nftContract);

        require(
            nft.ownerOf(tokenId) == listing.seller,
            "Seller no longer owns NFT"
        );

        require(
            nft.getApproved(tokenId) == address(this) ||
            nft.isApprovedForAll(listing.seller, address(this)),
            "Marketplace approval missing"
        );

        delete listings[nftContract][tokenId];

        uint256 fee = (listing.price * marketplaceFee) / FEE_DENOMINATOR;
        uint256 sellerAmount = listing.price - fee;

        nft.safeTransferFrom(
            listing.seller,
            msg.sender,
            tokenId
        );

        (bool sellerPaid, ) = payable(listing.seller).call{
            value: sellerAmount
        }("");

        require(sellerPaid, "Seller payment failed");

        emit NFTSold(
            nftContract,
            tokenId,
            listing.seller,
            msg.sender,
            listing.price
        );
    }

    function withdrawFees() external onlyOwner nonReentrant {
        uint256 balance = address(this).balance;

        require(balance > 0, "No fees");

        (bool success, ) = payable(owner()).call{value: balance}("");

        require(success, "Withdrawal failed");
    }
}