// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

//get funds from users
//withdraw funds
//set a minimum funding value in usd

import {PriceConverter} from './PriceConverter.sol';

contract FundMe {
    uint256 public miniUsd=1e18;
    address private owner;
    address[] private funders;
    mapping(address funder =>uint256 amount) funderToAmount;
    
    constructor(){
        owner=msg.sender;
    }

    function fund() public payable{
        require( msg.value>=miniUsd);
        funders.push(msg.sender);
        funderToAmount[msg.sender]=msg.value;
    }

    function withdraw() public onlyOwner{
        (bool success,)= payable(msg.sender).call{value:address(this).balance}('');
        require(success, 'withdraw failed');
        funders=new address[](0);
        for(uint256 i=0;i<funders.length;i++){
            address funderAddr = funders[i];
             funderToAmount[funderAddr]=0;
        }
    }

    modifier onlyOwner{
        require(owner==msg.sender);
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
      
    


}
