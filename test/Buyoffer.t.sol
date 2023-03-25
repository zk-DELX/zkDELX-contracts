// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Market.sol";
import "./utils/MockERC20.sol";
import {OfferStatus, Offer} from "../src/MarketStruct.sol";

contract BuyOffer is MarketEvent, Test {



    Market market;
    MockERC20 token;
    uint256 userPrivateKey;
    address user;
    uint256 supplierPrivateKey;
    address supplier;
    string _offerId;
    uint256 _price;
    uint256 _amount;


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


        
        // submit a offer
        vm.prank(supplier);
        _offerId = "testID";
        _amount = 1000;
        _price = 5 * 10 ** 5;
        address _paymentToken = address(token);
        string memory _location = "testLocation";
        
        market.submitOffer(_offerId, _amount, _price, _paymentToken, _location);

    }

    /**
     * buy offer
     */

    function test_buyOffer(uint256 buyAmount) public {
         vm.assume(buyAmount < _amount);
        // uint256 buyAmount = _amount - 20;
        /// @notice the vm.expectEmit must locate before the contract call
        vm.expectEmit(true, true, false, true);
        emit offerAccepted(buyAmount, _price, _offerId, address(user));

        vm.prank(user);
        market.buyOffer(_offerId, buyAmount);
    }
    
    
    // function testFailed_CxeedMaxAmount() public {

    // }
    /**
     * accepOffer
     */
    function test_acceptOffer() public {}

    /**
     * cancelOffer
     */

    function test_canceloffer() public {}

    /**
     * completeOffer
     */
    function test_completeOffer() public {}
}
