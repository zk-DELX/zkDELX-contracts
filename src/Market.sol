// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Market {
    uint256 private maxPrice;
    struct Offer {
        uint256 amount;
        uint256 price;
        string location; // ToDo: update to longitude/latitude
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
    modifier isValidOffer(uint256 _price) {
        require(_price <= maxPrice);
        _;
    }
    // This mapping only stores the current offer of each account
    // historical offers are stored off-chain, e.g., Polybase
    mapping(address => Offer) public offers; 
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
        string memory _location
    ) external {
        require(msg.sender == _offerAccount, "Cannot submit other's offer");
        offers[_offerAccount] = Offer({
            amount: _amount,
            price: _price,
            location: _location,
            status: OfferStatus.Listing
        });
        emit offerSubmitted(_amount, _price, _offerAccount);
    }

    function acceptOffer(address _offerAccount) external {
        require(
            offers[_offerAccount].status == OfferStatus.Listing,
            "Offer is not listed"
        );
        require(msg.sender != _offerAccount, "Cannot accept own offer");
        offers[_offerAccount].status = OfferStatus.Pending;
        emit offerAccepted(offers[_offerAccount].amount, offers[_offerAccount].price, _offerAccount, msg.sender);
    }

    /*
      @dev: buyer cancels an offer
    */
    function cancelOffer(address _offerAccount) external {
        require(
            offers[_offerAccount].status == OfferStatus.Pending,
            "Offer is not pending"
        );
        require(msg.sender != _offerAccount, "Cannot cancel own offer");        
        offers[_offerAccount].status = OfferStatus.Listing;
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
        delete offers[msg.sender]; // should we delete the offer?
    }

    function getOfferStatus(
        address _offerAccount
    ) public view returns (OfferStatus status) {
        status = offers[_offerAccount].status;
    }
}
