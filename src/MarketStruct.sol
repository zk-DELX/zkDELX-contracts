// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

struct Offer {
    uint256 amount;
    uint256 price;
    string loc_long; // ToDo: update to longitude/latitude
    string loc_lat;
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
