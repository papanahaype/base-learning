// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {BaseBuilderPassport} from "../src/BaseBuilderPassport.sol";

contract DeployBaseBuilderPassport is Script {
    function run() external returns (BaseBuilderPassport passport) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        passport = new BaseBuilderPassport(deployer);

        vm.stopBroadcast();
    }
}