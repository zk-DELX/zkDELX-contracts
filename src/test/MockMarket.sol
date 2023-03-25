// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import {Market} from "../../src/Market.sol";
import {OfferStatus, Offer} from "../../src/MarketStruct.sol";


contract MockMarket is Market {
  


  // need to instantiate the consturctor in the Market contract
  constructor(uint256 _maxPrice) Market(_maxPrice){

  }


      

}


