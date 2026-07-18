# Base Learning

A collection of Solidity smart contracts built while learning smart contract development on Base.

The repository contains educational implementations of ERC standards and DeFi primitives using Solidity and OpenZeppelin.

---

## Repository Structure

```text
base-learning/

├── ERC20/
├── B20/
├── erc721/
├── erc1155/
└── staking/
```

---

## Projects

### ERC20

Basic ERC20 token implementation.

Features:

- Mint
- Burn
- OpenZeppelin ERC20
- Ownership

---

### B20

Simple fungible token implementation deployed on Base.

Features:

- ERC20 compatible
- Mintable
- Burnable

---

### ERC721

NFT smart contract.

Features:

- Safe Mint
- URI storage
- Ownership
- OpenZeppelin ERC721

---

### ERC1155

Multi-token smart contract.

Features:

- Single mint
- Batch mint
- URI support
- OpenZeppelin ERC1155

---

### Staking

ERC20 staking protocol.

Features:

- Stake ERC20 tokens
- Reward distribution
- Claim rewards
- Lock period
- Emergency withdrawal
- Pause / Unpause
- AccessControl
- ReentrancyGuard
- SafeERC20

---

## Technologies

- Solidity ^0.8.24
- OpenZeppelin Contracts
- Remix IDE
- Base Network

---

## Learning Goals

This repository was created to practice:

- Smart contract development
- ERC token standards
- NFT development
- Multi-token standards
- DeFi staking mechanics
- Secure Solidity development
- OpenZeppelin best practices

---

## License

MIT