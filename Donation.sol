// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "./PriceConverter.sol"; // import the priceConverter library

contract Donation {

    using PriceConverter for uint256;

    address public owner; // store the owner of the contract 
    uint256 public constant MINIMUM_USD = 50 * 1e18; //$50 in USD

    mapping (address => uint256) public donations;
    address [] public funders; // keep a list of all donors

    event DonationReceived (address indexed donor, uint256 amount);


    constructor() {
        owner = msg.sender; // set the deployer as the owner of this contract
    }

    modifier onlyOwner() { 
        require (msg.sender == owner,"Only Owner can withdraw funds");// modifer to limit access to this function
        _;
    }
    //payable function to accept donations
    function fund () public payable {
        require(
            msg.value.getConversionRate() >= MINIMUM_USD);
        donations[msg.sender] += msg.value; //track the donation amount
        funders.push(msg.sender); //add the sender to the funders list
        emit DonationReceived (msg.sender , msg.value); // log the donations
    }

    function withdraw() public onlyOwner{
        uint256 contractBalance = address (this).balance;
        require(contractBalance >0 );

        //withdraw funds to the owner
        (bool success, ) = owner.call{value: contractBalance}("");
        require(success ,"Withdraw failed"); // revert if it fails
        
    }

   
    
}