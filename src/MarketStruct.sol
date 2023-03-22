// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

struct Offer {
    uint256 amount;
    uint256 price; // unit price (kw/hr)
    address paymentToken;
    string location; 
    OfferStatus status;
}

struct Bid {
    uint256 amount;
    uint256 price;
}

enum OfferStatus {
    Listing, // submitted to market by a seller; canceled from Pending
    Pending, // accepted by a buyer
    Complete // confirmed by a buyer
}
