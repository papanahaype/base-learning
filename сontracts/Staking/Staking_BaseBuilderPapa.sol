// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title StakingBaseBuilderPapa
 * @notice ERC20 staking contract with funded rewards, configurable limits,
 * withdrawal lock, emergency withdrawal, pausing and role-based control.
 *
 * @dev Reward accounting uses the cumulative reward-per-token model.
 * The contract must receive reward tokens through notifyRewardAmount()
 * before rewards can be distributed.
 *
 * This contract has not been audited.
 */
contract StakingBaseBuilderPapa is
    AccessControl,
    Pausable,
    ReentrancyGuard
{
    using SafeERC20 for IERC20;

    bytes32 public constant MANAGER_ROLE =
        keccak256("MANAGER_ROLE");

    uint256 private constant PRECISION = 1e18;

    IERC20 public immutable stakingToken;
    IERC20 public immutable rewardToken;

    uint256 public minimumStake;
    uint256 public maximumStakePerUser;
    uint256 public lockDuration;

    uint256 public totalStaked;

    mapping(address => uint256) private _balances;
    mapping(address => uint256) public unlockTime;

    uint256 public rewardRate;
    uint256 public rewardPeriodFinish;
    uint256 public lastRewardUpdate;
    uint256 public storedRewardPerToken;

    mapping(address => uint256)
        public userRewardPerTokenPaid;

    mapping(address => uint256)
        public pendingRewards;

    error ZeroAddress();
    error ZeroAmount();
    error InvalidLimits();
    error InvalidDuration();

    error StakeBelowMinimum(
        uint256 received,
        uint256 minimum
    );

    error MaximumStakeExceeded(
        uint256 resultingBalance,
        uint256 maximum
    );

    error InsufficientStake(
        uint256 available,
        uint256 requested
    );

    error StakeStillLocked(
        uint256 unlockTimestamp
    );

    error NoRewards();

    error RewardRateTooHigh(
        uint256 required,
        uint256 available
    );

    error ProtectedToken();

    error InsufficientRecoverableBalance(
        uint256 available,
        uint256 requested
    );

    event Staked(
        address indexed user,
        uint256 requestedAmount,
        uint256 receivedAmount,
        uint256 newBalance,
        uint256 unlockTimestamp
    );

    event Withdrawn(
        address indexed user,
        uint256 amount,
        uint256 remainingBalance
    );

    event RewardPaid(
        address indexed user,
        uint256 reward
    );

    event EmergencyWithdrawn(
        address indexed user,
        uint256 principalReturned,
        uint256 rewardsForfeited
    );

    event RewardProgramStarted(
        uint256 suppliedAmount,
        uint256 duration,
        uint256 rewardRate,
        uint256 periodFinish
    );

    event LimitsUpdated(
        uint256 minimumStake,
        uint256 maximumStakePerUser
    );

    event LockDurationUpdated(
        uint256 previousDuration,
        uint256 newDuration
    );

    event TokenRecovered(
        address indexed token,
        address indexed recipient,
        uint256 amount
    );

    constructor(
        address stakingToken_,
        address rewardToken_,
        address admin_,
        uint256 minimumStake_,
        uint256 maximumStakePerUser_,
        uint256 lockDuration_
    ) {
        if (
            stakingToken_ == address(0) ||
            rewardToken_ == address(0) ||
            admin_ == address(0)
        ) {
            revert ZeroAddress();
        }

        if (
            maximumStakePerUser_ == 0 ||
            minimumStake_ > maximumStakePerUser_
        ) {
            revert InvalidLimits();
        }

        stakingToken = IERC20(stakingToken_);
        rewardToken = IERC20(rewardToken_);

        minimumStake = minimumStake_;
        maximumStakePerUser =
            maximumStakePerUser_;

        lockDuration = lockDuration_;

        lastRewardUpdate = block.timestamp;

        _grantRole(
            DEFAULT_ADMIN_ROLE,
            admin_
        );

        _grantRole(
            MANAGER_ROLE,
            admin_
        );
    }

    modifier updateReward(
        address account
    ) {
        storedRewardPerToken =
            rewardPerToken();

        lastRewardUpdate =
            lastApplicableRewardTime();

        if (account != address(0)) {
            pendingRewards[account] =
                earned(account);

            userRewardPerTokenPaid[account] =
                storedRewardPerToken;
        }

        _;
    }

    function stake(
        uint256 amount
    )
        external
        nonReentrant
        whenNotPaused
        updateReward(msg.sender)
    {
        if (amount == 0) {
            revert ZeroAmount();
        }

        uint256 balanceBefore =
            stakingToken.balanceOf(
                address(this)
            );

        stakingToken.safeTransferFrom(
            msg.sender,
            address(this),
            amount
        );

        uint256 balanceAfter =
            stakingToken.balanceOf(
                address(this)
            );

        uint256 received =
            balanceAfter - balanceBefore;

        if (received == 0) {
            revert ZeroAmount();
        }

        if (received < minimumStake) {
            revert StakeBelowMinimum(
                received,
                minimumStake
            );
        }

        uint256 newBalance =
            _balances[msg.sender] +
            received;

        if (
            newBalance >
            maximumStakePerUser
        ) {
            revert MaximumStakeExceeded(
                newBalance,
                maximumStakePerUser
            );
        }

        _balances[msg.sender] =
            newBalance;

        totalStaked += received;

        uint256 newUnlockTime =
            block.timestamp +
            lockDuration;

        if (
            newUnlockTime >
            unlockTime[msg.sender]
        ) {
            unlockTime[msg.sender] =
                newUnlockTime;
        }

        emit Staked(
            msg.sender,
            amount,
            received,
            newBalance,
            unlockTime[msg.sender]
        );
    }

    function withdraw(
        uint256 amount
    )
        public
        nonReentrant
        updateReward(msg.sender)
    {
        if (amount == 0) {
            revert ZeroAmount();
        }

        uint256 userBalance =
            _balances[msg.sender];

        if (amount > userBalance) {
            revert InsufficientStake(
                userBalance,
                amount
            );
        }

        if (
            block.timestamp <
            unlockTime[msg.sender]
        ) {
            revert StakeStillLocked(
                unlockTime[msg.sender]
            );
        }

        _balances[msg.sender] =
            userBalance - amount;

        totalStaked -= amount;

        if (
            _balances[msg.sender] == 0
        ) {
            unlockTime[msg.sender] = 0;
        }

        stakingToken.safeTransfer(
            msg.sender,
            amount
        );

        emit Withdrawn(
            msg.sender,
            amount,
            _balances[msg.sender]
        );
    }

    function claimRewards()
        public
        nonReentrant
        updateReward(msg.sender)
    {
        uint256 reward =
            pendingRewards[msg.sender];

        if (reward == 0) {
            revert NoRewards();
        }

        pendingRewards[msg.sender] = 0;

        rewardToken.safeTransfer(
            msg.sender,
            reward
        );

        emit RewardPaid(
            msg.sender,
            reward
        );
    }

    function exit()
        external
    {
        uint256 userBalance =
            _balances[msg.sender];

        if (userBalance != 0) {
            withdraw(userBalance);
        }

        if (
            earned(msg.sender) != 0
        ) {
            claimRewards();
        }
    }

    function emergencyWithdraw()
        external
        nonReentrant
        updateReward(msg.sender)
    {
        uint256 principal =
            _balances[msg.sender];

        if (principal == 0) {
            revert ZeroAmount();
        }

        uint256 forfeitedRewards =
            pendingRewards[msg.sender];

        _balances[msg.sender] = 0;
        pendingRewards[msg.sender] = 0;
        unlockTime[msg.sender] = 0;

        totalStaked -= principal;

        stakingToken.safeTransfer(
            msg.sender,
            principal
        );

        emit EmergencyWithdrawn(
            msg.sender,
            principal,
            forfeitedRewards
        );
    }

    function notifyRewardAmount(
        uint256 amount,
        uint256 duration
    )
        external
        onlyRole(MANAGER_ROLE)
        nonReentrant
        updateReward(address(0))
    {
        if (amount == 0) {
            revert ZeroAmount();
        }

        if (duration == 0) {
            revert InvalidDuration();
        }

        uint256 balanceBefore =
            rewardToken.balanceOf(
                address(this)
            );

        rewardToken.safeTransferFrom(
            msg.sender,
            address(this),
            amount
        );

        uint256 balanceAfter =
            rewardToken.balanceOf(
                address(this)
            );

        uint256 received =
            balanceAfter - balanceBefore;

        if (received == 0) {
            revert ZeroAmount();
        }

        uint256 leftover;

        if (
            block.timestamp <
            rewardPeriodFinish
        ) {
            uint256 remaining =
                rewardPeriodFinish -
                block.timestamp;

            leftover =
                remaining *
                rewardRate;
        }

        rewardRate =
            (received + leftover) /
            duration;

        rewardPeriodFinish =
            block.timestamp +
            duration;

        lastRewardUpdate =
            block.timestamp;

        uint256 available =
            availableRewardBalance();

        uint256 required =
            rewardRate *
            duration;

        if (required > available) {
            revert RewardRateTooHigh(
                required,
                available
            );
        }

        emit RewardProgramStarted(
            received,
            duration,
            rewardRate,
            rewardPeriodFinish
        );
    }

    function setStakeLimits(
        uint256 minimumStake_,
        uint256 maximumStakePerUser_
    )
        external
        onlyRole(MANAGER_ROLE)
    {
        if (
            maximumStakePerUser_ == 0 ||
            minimumStake_ >
            maximumStakePerUser_
        ) {
            revert InvalidLimits();
        }

        minimumStake =
            minimumStake_;

        maximumStakePerUser =
            maximumStakePerUser_;

        emit LimitsUpdated(
            minimumStake_,
            maximumStakePerUser_
        );
    }

    function setLockDuration(
        uint256 newLockDuration
    )
        external
        onlyRole(MANAGER_ROLE)
    {
        uint256 previousDuration =
            lockDuration;

        lockDuration =
            newLockDuration;

        emit LockDurationUpdated(
            previousDuration,
            newLockDuration
        );
    }

    function pause()
        external
        onlyRole(MANAGER_ROLE)
    {
        _pause();
    }

    function unpause()
        external
        onlyRole(MANAGER_ROLE)
    {
        _unpause();
    }

    function recoverToken(
        address token,
        address recipient,
        uint256 amount
    )
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
        nonReentrant
    {
        if (
            token == address(0) ||
            recipient == address(0)
        ) {
            revert ZeroAddress();
        }

        if (amount == 0) {
            revert ZeroAmount();
        }

        if (
            token ==
            address(stakingToken)
        ) {
            revert ProtectedToken();
        }

        uint256 recoverable;

        if (
            token ==
            address(rewardToken)
        ) {
            uint256 rewardBalance =
                availableRewardBalance();

            uint256 committedRewards;

            if (
                block.timestamp <
                rewardPeriodFinish
            ) {
                committedRewards =
                    (
                        rewardPeriodFinish -
                        block.timestamp
                    ) *
                    rewardRate;
            }

            if (
                rewardBalance >
                committedRewards
            ) {
                recoverable =
                    rewardBalance -
                    committedRewards;
            }
        } else {
            recoverable =
                IERC20(token).balanceOf(
                    address(this)
                );
        }

        if (
            amount >
            recoverable
        ) {
            revert InsufficientRecoverableBalance(
                recoverable,
                amount
            );
        }

        IERC20(token).safeTransfer(
            recipient,
            amount
        );

        emit TokenRecovered(
            token,
            recipient,
            amount
        );
    }

    function balanceOf(
        address account
    )
        external
        view
        returns (uint256)
    {
        return _balances[account];
    }

    function lastApplicableRewardTime()
        public
        view
        returns (uint256)
    {
        if (
            block.timestamp <
            rewardPeriodFinish
        ) {
            return block.timestamp;
        }

        return rewardPeriodFinish;
    }

    function rewardPerToken()
        public
        view
        returns (uint256)
    {
        if (totalStaked == 0) {
            return storedRewardPerToken;
        }

        uint256 timeDifference =
            lastApplicableRewardTime() -
            lastRewardUpdate;

        uint256 rewardIncrease =
            (
                timeDifference *
                rewardRate *
                PRECISION
            ) /
            totalStaked;

        return
            storedRewardPerToken +
            rewardIncrease;
    }

    function earned(
        address account
    )
        public
        view
        returns (uint256)
    {
        uint256 rewardDifference =
            rewardPerToken() -
            userRewardPerTokenPaid[
                account
            ];

        uint256 newlyEarned =
            (
                _balances[account] *
                rewardDifference
            ) /
            PRECISION;

        return
            newlyEarned +
            pendingRewards[account];
    }

    function availableRewardBalance()
        public
        view
        returns (uint256)
    {
        uint256 balance =
            rewardToken.balanceOf(
                address(this)
            );

        if (
            address(rewardToken) ==
            address(stakingToken)
        ) {
            if (
                balance >
                totalStaked
            ) {
                return
                    balance -
                    totalStaked;
            }

            return 0;
        }

        return balance;
    }

    function rewardProgram()
        external
        view
        returns (
            uint256 rate,
            uint256 finish,
            uint256 lastUpdate,
            uint256 availableRewards
        )
    {
        return (
            rewardRate,
            rewardPeriodFinish,
            lastRewardUpdate,
            availableRewardBalance()
        );
    }
}