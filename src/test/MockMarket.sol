// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import {Market} from "../../src/Market.sol";
import {OfferStatus, Offer} from "../../src/MarketStruct.sol";

import {MarketEvent} from "../MarketEvent.sol";

contract MockMarket is Market {
    // need to instantiate the consturctor in the Market contract
    constructor(uint256 _maxPrice) Market(_maxPrice) {}

    function insertOffer(
        string memory _offerId,
        Offer memory _offer
    ) public {
      offers[_offerId] = Offer(
        _offer.amount,
        _offer.currBuyAmount,
        _offer.price,
        _offer.paymentToken,
        _offer.location,
       _offer.status,
       _offer.sellerAccount,
       _offer.buyerAccount
      );
    }
}
