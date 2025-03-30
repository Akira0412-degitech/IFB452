// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeliveryFeedback {

    address public customer;
    uint public deliveryScore;
    bool public isRated;


    constructor(address _customer){
        require(_customer != address(0), "Invalid address");
        customer = _customer;
        isRated = false;
    }

    modifier onlyCustomer(){
        require(msg.sender == customer, "You are not the customer");
        _;
    }


    event DeliveryRated(uint newScore);

    function updateRate(uint _score) public onlyCustomer{
        require(isRated == false, "You have rated alredy");
        require(_score > 0 && _score <100, "Rate should be between 0 and 100 inclusive");
        isRated = true;
        deliveryScore = _score;

        emit DeliveryRated(deliveryScore);
    }
}