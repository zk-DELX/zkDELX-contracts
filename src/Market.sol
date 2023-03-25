// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import {MarketEvent} from "./MarketEvent.sol";
import {OfferStatus, Offer} from "./MarketStruct.sol";

contract Market is MarketEvent, Ownable {
    uint256 private maxPrice;

    modifier isValidOffer(uint256 _price) {
        require(_price <= maxPrice);
        _;
    }
    // This mapping only stores the current offer of each account
    // historical offers are stored off-chain, e.g., Polybase
    mapping(string => Offer) public offers;
    // mapping(address => Listing) public listings; // store seller's offers

    // paymentToken address whitelist
    using EnumerableSet for EnumerableSet.AddressSet;
    EnumerableSet.AddressSet paymentTokenWhitelist;

    constructor(uint256 _maxPrice) {
        maxPrice = _maxPrice; // 1000 USD cents
    }

    /**
     * Seller updates an Linsting offer; stores to Listing.
     */
    // function updateOffer() public {
    //     // Token consumer => smartContract => provider
    // }

    /**
     * Seller submits an offer; stores to Listing.
     */
    function submitOffer(
        string calldata _offerID,
        uint256 _amount,
        uint256 _price,
        address _paymentToken,
        string calldata _location
    ) external {
        require(
            isPaymentWhitelisted(_paymentToken),
            "PAYMENT METHOD NOT WHITELIST"
        );
        offers[_offerID] = Offer({
            amount: _amount,
            currBuyAmount: 0,
            price: _price,
            paymentToken: _paymentToken,
            location: _location,
            status: OfferStatus.Listing,
            sellerAccount: msg.sender,
            buyerAccount: address(0)
        });
        emit offerSubmitted(_amount, _price, _offerID);
    }

    function approveBeforeBuy(
        string calldata _offerID,
        uint256 _amount
    ) external {
        uint256 finalPrice = offers[_offerID].price * _amount;
        IERC20(offers[_offerID].paymentToken).approve(
            address(this),
            finalPrice
        );
    }

    /**
     * Buyer accpets the offer from user and deposite the amount to this contract
     */
    function buyOffer(string calldata _offerID, uint256 _amount) external {
        require(
            offers[_offerID].status == OfferStatus.Listing,
            "Offer is not listed"
        );
        
        require(offers[_offerID].amount > _amount, "Exceed max amount");
        
        require(
            offers[_offerID].sellerAccount != msg.sender,
            "Cannot accept own offer"
        );
        // final price
        uint256 finalPrice = offers[_offerID].price * _amount;

        // deposite amount to this contract
        IERC20(offers[_offerID].paymentToken).transferFrom(
            msg.sender,
            address(this),
            finalPrice
        );
        
        offers[_offerID].buyerAccount = msg.sender;
        offers[_offerID].status = OfferStatus.Pending;
        offers[_offerID].currBuyAmount = _amount;
        offers[_offerID].amount -= _amount;

        emit offerAccepted(
            _amount,
            offers[_offerID].price,
            _offerID,
            msg.sender
        );
    }

    /*
      @dev: buyer cancels an offer and return the deposit 
    */
    function cancelOffer(string calldata _offerID) external {
        require(
            offers[_offerID].status == OfferStatus.Pending,
            "Offer is not pending"
        );
        require(
            msg.sender != offers[_offerID].buyerAccount,
            "Cannot cancel other's offer"
        );
        // refund price
        uint256 refundPrice = offers[_offerID].price *
            offers[_offerID].currBuyAmount;
        // refund the deposite
        IERC20(offers[_offerID].paymentToken).approve(msg.sender, refundPrice);
        IERC20(offers[_offerID].paymentToken).transfer(msg.sender, refundPrice);
        offers[_offerID].status = OfferStatus.Listing;
        offers[_offerID].amount += offers[_offerID].currBuyAmount;
        offers[_offerID].currBuyAmount = 0;
    }

    /*
      @dev: seller deletes an offer
    */
    function deleteOffer(string calldata _offerID) external {
        require(
            msg.sender == offers[_offerID].sellerAccount,
            "Cannot del other's offer"
        );
        require(
            offers[_offerID].status == OfferStatus.Listing,
            "Cannot del nonListing offer"
        );
        delete offers[_offerID];
    }

    /*
      @dev: buyer confirms an offer is complete and transfer to seller
      TODO: AA handles this process
    */
    function completeOffer(string calldata _offerID) external {
        require(
            offers[_offerID].status == OfferStatus.Pending,
            "Offer is not pending"
        );
        require(
            msg.sender != offers[_offerID].sellerAccount,
            "Cannot complete own offer"
        );
        offers[_offerID].status = OfferStatus.Complete;

        
        uint256 currBuyAmount = offers[_offerID].currBuyAmount;
        // final price
        uint256 finalPrice = offers[_offerID].price *
            offers[_offerID].currBuyAmount;

        // transfer the stablecoine to offerer
        // IERC20(offers[_offerID].paymentToken).approve(msg.sender, finalPrice);
        IERC20(offers[_offerID].paymentToken).transfer(offers[_offerID].sellerAccount, finalPrice);
        // delete offers[_offerID]; // active offer deleted
        offers[_offerID].status = OfferStatus.Listing;
        offers[_offerID].buyerAccount = address(0);
        offers[_offerID].currBuyAmount = 0;
        emit offerComplete(
            currBuyAmount,
            offers[_offerID].price,
            block.timestamp,
            _offerID
        );
    }

    // paymentTokenWhitelist operations

    function isPaymentWhitelisted(
        address _paymentToken
    ) public view returns (bool) {
        return paymentTokenWhitelist.contains(_paymentToken);
    }

    function addPaymentToken(address _paymentToken) external onlyOwner {
        require(!isPaymentWhitelisted(_paymentToken), "PAYMENT EXIST");
        paymentTokenWhitelist.add(_paymentToken);
    }

    function removePaymentToken(address _paymentToken) external onlyOwner {
        require(isPaymentWhitelisted(_paymentToken), "PAYMENT NOT EXIST");
        paymentTokenWhitelist.remove(_paymentToken);
    }

    /**
     * @notice ERC20 token balance validation
     */
    function _validateERC20BalAndAllowance(
        address _addrToCheck,
        address _currency,
        uint256 _currencyAmountToCheckAgainst
    ) internal view {
        // check payment token in whitelist
        require(
            isPaymentWhitelisted(address(_currency)),
            "PAYMENT TOKEN NOT ALLOWED"
        );

        require(
            IERC20(_currency).balanceOf(_addrToCheck) >=
                _currencyAmountToCheckAgainst &&
                IERC20(_currency).allowance(_addrToCheck, address(this)) >=
                _currencyAmountToCheckAgainst,
            "NOT SUFFICIENT BAL"
        );
    }
}
