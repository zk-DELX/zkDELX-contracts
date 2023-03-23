// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

struct Offer {
    uint256 amount; // initially max amount
    uint256 currBuyAmount; // current buy amount kwh
    uint256 price; // unit price (cents/kwr)
    address paymentToken;
    string location;
    OfferStatus status;
    address sellerAccount;
    address buyerAccount;
}

enum OfferStatus {
    Listing, // submitted to market by a seller; canceled from Pending
    Pending, // accepted by a buyer
    Complete // confirmed by a buyer
}
