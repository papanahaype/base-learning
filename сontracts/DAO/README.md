# DAO Governance on Base

A decentralized governance system built on Base using OpenZeppelin Governor and Timelock contracts.

## Overview

This project demonstrates how on-chain governance works through proposals, voting, timelock execution, and decentralized control over protocol parameters.

The governance process follows the standard lifecycle:

1. Create a proposal.
2. Community votes.
3. Successful proposal is queued in the Timelock.
4. After the delay expires, the proposal is executed automatically through governance.

## Contracts

### PapaGovernanceToken

Governance token based on OpenZeppelin.

Features:

- ERC20
- ERC20Permit
- ERC20Votes
- ERC20Capped
- AccessControl

Used for proposal creation and voting.

---

### PapaGovernor

Main governance contract.

Responsible for:

- proposal creation
- voting
- quorum verification
- proposal state management
- queueing successful proposals
- execution through Timelock

---

### PapaTimelock

Execution layer for governance.

Functions:

- stores successful proposals
- enforces execution delay
- protects against immediate execution
- executes approved governance actions

## Governance Flow

Proposal

↓

Voting

↓

Succeeded

↓

Queue

↓

Timelock Delay

↓

Execute

↓

State Updated

## Technologies

- Solidity
- OpenZeppelin Contracts
- Governor
- TimelockController
- ERC20Votes
- Remix IDE
- Base Network

## Example

The project includes a complete governance example where the community successfully changes the Timelock delay through an on-chain proposal without any administrator intervention.

## Learning Goals

- Understand decentralized governance.
- Learn Governor architecture.
- Work with ERC20Votes.
- Execute proposals through Timelock.
- Build secure DAO workflows.
- Understand proposal lifecycle and governance security.

## License

MIT