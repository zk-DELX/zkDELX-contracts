// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Market.sol";
import "./utils/MockERC20.sol";


contract MarketTest is MarketEvent, Test {
    Market market;
    MockERC20 token;
    uint256 userPrivateKey;
    address user;
    uint256 supplierPrivateKey;
    address supplier;
    function setUp() public {
      

      // user PK
      userPrivateKey = 0xA11CE;
      user = vm.addr(userPrivateKey);

      // electricity supplier PK
      supplierPrivateKey = 0xB8B;
      supplier = vm.addr(supplierPrivateKey);
       
      


      // mockERC20 with 6 decimals as stablecoin payment
      token = new MockERC20();
      token.mint(user, 1e18);

  

      
      uint256 maxValue = 10000*10**6;
      market = new Market(maxValue);
      

      // add token address into the whitelist 
      market.addPaymentToken(address(token));
      // token approval
      vm.prank(user);
      token.approve(address(market), 10**18);

    }


    /**
     * submit offer tests
     */

    function test_submiteOffer() public {
      

      address offerAccount = address(supplier);
      uint256 amount = 1000;
      uint256 price = 10**6;
      address paymentToken = address(token);
      string memory long = "10.00";
      string memory lat = "10.00";
      
      /// @notice the vm.expectEmit must locate before the contract call
      vm.expectEmit(true, true, false, true);
      emit offerSubmitted(amount, price, offerAccount);
      
      vm.prank(supplier);
      market.submitOffer(offerAccount, amount, price, paymentToken, long, lat);

    

    }

    /**
     * accepOffer
     */
    function test_acceptOffer() public {

    }

    /**
     * cancelOffer
     */

    function test_canceloffer() public {

    }

    /**
     * completeOffer
     */
    function test_completeOffer() public {

    }


}
