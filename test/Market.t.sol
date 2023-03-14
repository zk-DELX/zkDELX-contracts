// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Market.sol";

contract MarketTest is Test {
    Market market;
    function setUp() public {
      market = new Market(10000);
    }

    // function testMaxPrice() public {
    //   uint256 _maxPrice = market.maxPrice();
    //   assertTrue(_);
    // }
}
