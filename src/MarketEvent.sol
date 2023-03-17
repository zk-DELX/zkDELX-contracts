// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface MarketEvent {
   event offerSubmitted(
        uint256 indexed _amount,
        uint256 indexed _price,
        address _offerAccount
    );
    event offerAccepted(
        uint256 indexed _amount,
        uint256 indexed _price,
        address _offerAccount,
        address _buyerAccount
    );
    event offerCancelled(
        uint256 indexed _amount,
        uint256 indexed _price,
        address _offerAccount
    );
    event offerExperied(
        uint256 indexed _amount,
        uint256 indexed _price,
        address _offerAccount
    );
    event offerComplete(
        uint256 indexed _amount,
        uint256 indexed _price,
        uint256 _completeTime,
        address _offerAccount
    );
}

