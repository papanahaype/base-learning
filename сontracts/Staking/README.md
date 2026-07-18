\# Staking Base Builder Papa



An ERC20 staking smart contract built with Solidity and OpenZeppelin.



This project allows users to stake ERC20 tokens, earn reward tokens over time, claim rewards, and withdraw their stake after the lock period.



\---



\## Features



\- ERC20 staking

\- Reward distribution over time

\- Configurable reward duration

\- Minimum and maximum staking limits

\- Lock period for withdrawals

\- Emergency withdrawal

\- Role-based access control

\- Pause / unpause functionality

\- Reentrancy protection

\- Safe ERC20 transfers using OpenZeppelin

\- Custom errors for gas optimization



\---



\## Contracts



\### PapaStakingToken.sol



Simple ERC20 token used for testing the staking contract.



\### Staking\_BaseBuilderPapa.sol



Main staking contract that manages deposits, rewards, and withdrawals.



\---



\## Main Functions



\### User



\- stake()

\- withdraw()

\- claimRewards()

\- emergencyWithdraw()

\- earned()

\- balanceOf()



\### Administrator



\- notifyRewardAmount()

\- setStakeLimits()

\- setLockDuration()

\- pause()

\- unpause()

\- recoverToken()



\---



\## Technologies



\- Solidity ^0.8.24

\- OpenZeppelin Contracts

\- Remix IDE

\- Base Network



\---



\## Tested Workflow



The contract has been successfully tested with the following flow:



1\. Deploy PapaStakingToken

2\. Deploy Staking\_BaseBuilderPapa

3\. Approve staking contract

4\. Fund reward pool

5\. Stake tokens

6\. Accumulate rewards

7\. Claim rewards

8\. Withdraw staked tokens



\---



\## Security



The contract includes several security mechanisms:



\- AccessControl

\- ReentrancyGuard

\- Pausable

\- SafeERC20

\- Protected reward accounting

\- Custom Solidity errors



\---



\## License



MIT

