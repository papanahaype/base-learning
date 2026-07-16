// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract BaseBuilderPapaAirdrop {
    address public owner;

    struct Recipient {
        uint256 amount;
        bool claimed;
    }

    mapping(address => Recipient) public recipients;

    event RecipientAdded(address indexed recipient, uint256 amount);
    event AirdropClaimed(address indexed recipient, uint256 amount);
    event ContractFunded(address indexed sender, uint256 amount);
    event FundsWithdrawn(address indexed owner, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {
        emit ContractFunded(msg.sender, msg.value);
    }

    function addRecipient(
        address recipient,
        uint256 amount
    ) external onlyOwner {
        require(recipient != address(0), "Invalid address");
        require(amount > 0, "Amount must be greater than zero");
        require(!recipients[recipient].claimed, "Recipient already claimed");

        recipients[recipient] = Recipient({
            amount: amount,
            claimed: false
        });

        emit RecipientAdded(recipient, amount);
    }

    function claim() external {
        Recipient storage recipient = recipients[msg.sender];
        uint256 amount = recipient.amount;

        require(amount > 0, "Not eligible");
        require(!recipient.claimed, "Already claimed");
        require(address(this).balance >= amount, "Insufficient contract balance");

        recipient.claimed = true;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "ETH transfer failed");

        emit AirdropClaimed(msg.sender, amount);
    }

    function claimAmount(address user) external view returns (uint256) {
        return recipients[user].amount;
    }

    function hasClaimed(address user) external view returns (bool) {
        return recipients[user].claimed;
    }

    function contractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function withdrawRemainingFunds() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");

        (bool success, ) = payable(owner).call{value: balance}("");
        require(success, "Withdrawal failed");

        emit FundsWithdrawn(owner, balance);
    }
}