# Base Learning

A collection of Solidity smart contracts built while learning smart contract development on Base.

The repository contains educational implementations of ERC standards, DeFi primitives, on-chain governance, and NFT marketplace mechanics using Solidity and OpenZeppelin.

---

## Repository Structure

```text
base-learning/

├── ERC20/
├── B20/
├── ERC721/
├── ERC1155/
├── Staking/
├── Vault/
├── DAO/
└── Marketplace/
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
- URI Storage
- Ownership
- OpenZeppelin ERC721

---

### ERC1155

Multi-token smart contract.

Features:

- Single Mint
- Batch Mint
- URI Support
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

### Vault

ERC4626 tokenized vault implementation.

Features:

- ERC4626
- Deposit assets
- Mint vault shares
- Withdraw assets
- Redeem vault shares
- Vault Cap
- AccessControl
- Pause / Unpause
- ReentrancyGuard

---

### DAO

Decentralized governance system built with OpenZeppelin Governor and Timelock.

Features:

- ERC20Votes governance token
- Governor
- TimelockController
- Proposal creation
- On-chain voting
- Queue & Execute
- Governance-controlled protocol parameters

---

### Marketplace — Day 9

Non-custodial ERC721 NFT marketplace built and tested on Base Mainnet.

Completed: September 30, 2026.

Features:

- ERC721 NFT minting
- Marketplace approval
- NFT listing
- Listing price updates
- Listing cancellation
- NFT purchases with ETH
- Automatic NFT transfer to buyer
- Seller payment
- 2.5% marketplace fee
- Fee withdrawal
- Reentrancy protection
- Ownership and approval validation

Contracts:

**Papa721NFT**

`0x28cFc025993d77fcfbc1cd92BF37F13148869BE5`

**PapaMarketplace**

`0x81c56C758dE3a9F8df90a12A18f2a8A20153c021`

The complete marketplace lifecycle was successfully tested on Base Mainnet using two wallets.

---

## Technologies

- Solidity ^0.8.20 / ^0.8.24
- OpenZeppelin Contracts v5
- Remix IDE
- Base Network

---

## Learning Goals

This repository was created to practice:

- Smart contract development
- ERC token standards
- NFT development
- Multi-token standards
- ERC4626 tokenized vaults
- DeFi staking mechanics
- DAO governance
- Timelock execution
- NFT marketplace architecture
- Non-custodial NFT trading
- Marketplace fees
- Secure Solidity development
- OpenZeppelin best practices

---

## Progress

- Day 1 — SimpleStorage
- Day 2 — ERC20
- Day 3 — B20
- Day 4 — ERC721
- Day 5 — ERC1155
- Day 6 — Staking
- Day 7 — ERC4626 Vault
- Day 8 — DAO Governance
- Day 9 — NFT Marketplace 

---

## License

MIT