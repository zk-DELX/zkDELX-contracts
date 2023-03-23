// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface MarketEvent {
    event offerSubmitted(
        uint256 indexed _amount,
        uint256 indexed _price,
        string _offerID
    );
    event offerAccepted(
        uint256 indexed _amount,
        uint256 indexed _price,
        string _offerID,
        address _buyerAccount
    );
    event offerCancelled(
        uint256 indexed _amount,
        uint256 indexed _price,
        string _offerID
    );
    event offerExperied(
        uint256 indexed _amount,
        uint256 indexed _price,
        string _offerID
    );
    event offerComplete(
        uint256 indexed _amount,
        uint256 indexed _price,
        uint256 _completeTime,
        string _offerID
    );
}
