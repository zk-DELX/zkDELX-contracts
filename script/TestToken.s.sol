// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {TestToken} from "../src/test/TestToken.sol";

contract ContractScript is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();
        address minter = 0xb72D7383D233697B74c672BAa0B0BfeCAAc10B99;
        new TestToken(minter);
    }
}
