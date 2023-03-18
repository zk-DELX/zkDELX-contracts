// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import {MarketEvent} from "./MarketEvent.sol";
import "./MarketStruct.sol";

contract Market is MarketEvent {
    uint256 private maxPrice;

    modifier isValidOffer(uint256 _price) {
        require(_price <= maxPrice);
        _;
    }
    // This mapping only stores the current offer of each account
    // historical offers are stored off-chain, e.g., Polybase
    mapping(address => Offer) public offers;

    // paymentToken address whitelist
    using EnumerableSet for EnumerableSet.AddressSet;
    EnumerableSet.AddressSet paymentTokenWhitelist;

    constructor(uint256 _maxPrice) {
        maxPrice = _maxPrice;
    }

    function charge() public {
        // Token consumer => smartContract => provider
    }

    function submitOffer(
        address _offerAccount,
        uint256 _amount,
        uint256 _price,
        address _paymentToken,
        string calldata _loc_long,
        string calldata _loc_lat
    ) external {
        require(msg.sender == _offerAccount, "Cannot submit other's offer");
        require(isPaymentWhitelisted(_paymentToken), "PAYMENT METHOD NOT WHITELIST");
        offers[_offerAccount] = Offer({
            amount: _amount,
            price: _price,
            paymentToken: _paymentToken,
            loc_long: _loc_long,
            loc_lat: _loc_lat,
            status: OfferStatus.Listing
        });
        emit offerSubmitted(_amount, _price, _offerAccount);
    }

    function acceptOffer(address _offerAccount) external {
        require(
            offers[_offerAccount].status == OfferStatus.Listing,
            "Offer is not listed"
        );
        require(msg.sender != _offerAccount, "Cannot accept own offer");
        offers[_offerAccount].status = OfferStatus.Pending;
        emit offerAccepted(
            offers[_offerAccount].amount,
            offers[_offerAccount].price,
            _offerAccount,
            msg.sender
        );
    }

    /*
      @dev: buyer cancels an offer
    */
    function cancelOffer(address _offerAccount) external {
        require(
            offers[_offerAccount].status == OfferStatus.Pending,
            "Offer is not pending"
        );
        require(msg.sender != _offerAccount, "Cannot cancel own offer");
        offers[_offerAccount].status = OfferStatus.Listing;
    }

    /*
      @dev: seller deletes an offer
    */
    function deleteOffer(address _offerAccount) external {
        require(msg.sender == _offerAccount, "Cannot delete other's offer");
        delete offers[msg.sender];
    }

    /*
      @dev: buyer confirms an offer is complete and transfer to seller
      TODO: AA handles this process
    */
    function completeOffer(address _offerAccount) external {
        require(
            offers[_offerAccount].status == OfferStatus.Pending,
            "Offer is not pending"
        );
        require(msg.sender != _offerAccount, "Cannot complete own offer");
        offers[_offerAccount].status = OfferStatus.Complete;

        // transfer the stablecoine to offerer
        IERC20(offers[_offerAccount].paymentToken).transfer(
            msg.sender,
            offers[_offerAccount].price
        );
        delete offers[msg.sender]; // should we delete the offer?
    }

    function getOfferStatus(
        address _offerAccount
    ) public view returns (OfferStatus status) {
        status = offers[_offerAccount].status;
    }

    // paymentTokenWhitelist operations

    function isPaymentWhitelisted(
        address _paymentToken
    ) public view returns (bool) {
        return paymentTokenWhitelist.contains(_paymentToken);
    }

    function addPaymentToken(address _paymentToken) external {
        require(!isPaymentWhitelisted(_paymentToken), "PAYMENT EXIST");
        paymentTokenWhitelist.add(_paymentToken);
    }

    function removePaymentToken(address _paymentToken) external {
        require(isPaymentWhitelisted(_paymentToken), "PAYMENT NOT EXIST");
        paymentTokenWhitelist.remove(_paymentToken);
    }
}
