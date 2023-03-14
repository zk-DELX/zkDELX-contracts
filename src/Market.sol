// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Market {
  uint256 private maxPrice;
  struct Offer {
    uint256 amount;
    uint256 price;
    string location;
  }

  struct Bid {
    uint256 amount;
    uint256 price;
  }

  modifier isValidOffer(uint256 _price) {
    require(_price <= maxPrice);
    _;
  }

  mapping(address => Offer) public offers;
  mapping(address => Bid) public bids;

  constructor(uint256 _maxPrice) {
    maxPrice = _maxPrice;
  }

  function charge() public {
    // Token consumer => smartContract => provider
  }
}