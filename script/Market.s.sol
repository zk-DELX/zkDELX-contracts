// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {Market} from "../src/Market.sol";

contract ContractScript is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();
        uint256 maxVal = 1000 * 10 ** 6;
        new Market(maxVal);
    }
}
