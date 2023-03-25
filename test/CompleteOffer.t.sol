// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/test/MockMarket.sol";
import "./utils/MockERC20.sol";
import {OfferStatus, Offer} from "../src/MarketStruct.sol";

contract CompleteOffer is MarketEvent, Test {



    MockMarket market;
    MockERC20 token;
    uint256 userPrivateKey;
    address user;
    uint256 supplierPrivateKey;
    address supplier;
    string _offerId;
    uint256 _price;
    uint256 _amount;
    uint256 _currBuyAmount;


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
        market = new MockMarket(maxValue);

        token.mint(address(market), 1e18);

        // add token address into the whitelist
        market.addPaymentToken(address(token));
        // token approval
        vm.prank(user);
        token.approve(address(market), 10 ** 18);


        
        // inert a offer
        vm.prank(supplier);
        _offerId = "testID";
        _amount = 1000;
        _currBuyAmount = 50;
        _price = 5 * 10 ** 5;
        address _paymentToken = address(token);
        string memory _location = "testLocation";
        OfferStatus _status = OfferStatus.Pending;

        Offer memory pendingOffer = Offer(
            _amount,
            _currBuyAmount,
            _price,
            _paymentToken,
            _location,
            _status,
            address(supplier),
            address(user)
        );
        
        market.insertOffer(_offerId, pendingOffer);

    }

    /**
     * buy offer
     */

    function test_CompleteOffer() public {

        uint256 previousBalance = token.balanceOf(supplier);

        /// @notice the vm.expectEmit must locate before the contract call
        vm.expectEmit(true, true, false, true);
        emit offerComplete(_currBuyAmount, _price, block.timestamp, _offerId);

        vm.prank(user);
        market.completeOffer(_offerId);

        uint256 finalPrice = _currBuyAmount * _price;
        
        uint256 afterBalance = token.balanceOf(supplier);
        assertEq(afterBalance - finalPrice, previousBalance);
    }

    // /// helper function
    // function insertPendingOffer(string memory offerId, Offer memory offer) internal {
        
    //     MockMarket.insertOffer(offerId, offer);

    // }
    

}
