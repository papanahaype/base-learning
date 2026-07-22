// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract PapaVault is ERC4626, AccessControl, Pausable, ReentrancyGuard {
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");

    uint256 public vaultCap;

    constructor(
        IERC20 asset_,
        uint256 vaultCap_
    )
        ERC20("Papa Vault Share", "vPVT")
        ERC4626(asset_)
    {
        require(vaultCap_ > 0, "Cap must be greater than zero");

        vaultCap = vaultCap_;

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(MANAGER_ROLE, msg.sender);
    }

    function setVaultCap(uint256 newCap)
        external
        onlyRole(MANAGER_ROLE)
    {
        require(newCap >= totalAssets(), "Cap below total assets");
        vaultCap = newCap;
    }

    function pause() external onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() external onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function maxDeposit(address)
        public
        view
        override
        returns (uint256)
    {
        if (totalAssets() >= vaultCap) {
            return 0;
        }

        return vaultCap - totalAssets();
    }

    function maxMint(address)
        public
        view
        override
        returns (uint256)
    {
        return convertToShares(maxDeposit(address(0)));
    }

    function deposit(uint256 assets, address receiver)
        public
        override
        whenNotPaused
        nonReentrant
        returns (uint256)
    {
        return super.deposit(assets, receiver);
    }

    function mint(uint256 shares, address receiver)
        public
        override
        whenNotPaused
        nonReentrant
        returns (uint256)
    {
        return super.mint(shares, receiver);
    }

    function withdraw(
        uint256 assets,
        address receiver,
        address owner
    )
        public
        override
        whenNotPaused
        nonReentrant
        returns (uint256)
    {
        return super.withdraw(assets, receiver, owner);
    }

    function redeem(
        uint256 shares,
        address receiver,
        address owner
    )
        public
        override
        whenNotPaused
        nonReentrant
        returns (uint256)
    {
        return super.redeem(shares, receiver, owner);
    }

    function _decimalsOffset()
        internal
        pure
        override
        returns (uint8)
    {
        return 3;
    }
}