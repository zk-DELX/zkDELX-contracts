// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Market.sol";

contract MarketTest is Test {
    Market market;
    function setUp() public {
      address paymentTokenAddress = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
      market = new Market(10000, paymentTokenAddress);
    }

    // function testMaxPrice() public {
    //   uint256 _maxPrice = market.maxPrice();
    //   assertTrue(_);
    // }
}
