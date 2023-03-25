// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Market.sol";
import "./utils/MockERC20.sol";
import {OfferStatus, Offer} from "../src/MarketStruct.sol";

contract SubmitOffer is MarketEvent, Test {


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

        token = new MockERC20();
        token.mint(user, 1e18);

        uint256 maxValue = 10000 * 10 ** 18;
        market = new Market(maxValue);

        // add token address into the whitelist
        market.addPaymentToken(address(token));
        // token approval
        vm.prank(user);
        token.approve(address(market), 10 ** 18);
    }

    /**
     * submit offer tests
     */

    function test_submiteOffer() public {
        string memory _offerId = "testID";
        uint256 _amount = 1000;
        uint256 _price = 5 * 10 ** 5;
        address _paymentToken = address(token);
        string memory _location = "testLocation";

        // // create a offer
        // Offer newOffer =  Offer({
        //       amount: _amount,
        //       currBuyAmount: 0,
        //       price: _price,
        //       paymentToken: _paymentToken,
        //       location: _location,
        //       status: OfferStatus.Listing,
        //       sellerAccount: msg.sender,
        //       buyerAccount: address(0)
        //   });

        /// @notice the vm.expectEmit must locate before the contract call
        vm.expectEmit(true, true, false, true);
        emit offerSubmitted(_amount, _price, _offerId);

        vm.prank(supplier);
        market.submitOffer(_offerId, _amount, _price, _paymentToken, _location);
    }
}
