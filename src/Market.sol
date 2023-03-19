// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import {MarketEvent} from "./MarketEvent.sol";
import "./MarketStruct.sol";

contract Market is MarketEvent, Ownable {
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
        string calldata _location
    ) external {
        require(msg.sender == _offerAccount, "Cannot submit other's offer");
        require(isPaymentWhitelisted(_paymentToken), "PAYMENT METHOD NOT WHITELIST");
        offers[_offerAccount] = Offer({
            amount: _amount,
            price: _price,
            paymentToken: _paymentToken,
            location: _location,
            status: OfferStatus.Listing
        });
        emit offerSubmitted(_amount, _price, _offerAccount);
    }
    
    /**
     * Accpet the offer from user and deposite the amount to this contract
     */
    function acceptOffer(address _offerAccount) external {

        require(
            offers[_offerAccount].status == OfferStatus.Listing,
            "Offer is not listed"
        );
        require(msg.sender != _offerAccount, "Cannot accept own offer");
        offers[_offerAccount].status = OfferStatus.Pending;

        // deposite amount to this contract 
        IERC20(offers[_offerAccount].paymentToken).transferFrom(msg.sender, address(this), offers[_offerAccount].price);
        
        emit offerAccepted(
            offers[_offerAccount].amount,
            offers[_offerAccount].price,
            _offerAccount,
            msg.sender
        );
    }

    /*
      @dev: buyer cancels an offer and return the deposit 
    */
    function cancelOffer(address _offerAccount) external {
        require(
            offers[_offerAccount].status == OfferStatus.Pending,
            "Offer is not pending"
        );
        require(msg.sender != _offerAccount, "Cannot cancel own offer");
        offers[_offerAccount].status = OfferStatus.Listing;

        // return the deposite
        IERC20(offers[_offerAccount].paymentToken).transfer(msg.sender, offers[_offerAccount].price);
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
        delete offers[msg.sender]; // active offer deleted
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
                IERC20(_currency).allowance(
                    _addrToCheck,
                    address(this)
                ) >=
                _currencyAmountToCheckAgainst,
            "NOT SUFFICIENT BAL"
        );
    }
}
