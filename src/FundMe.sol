// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

//get funds from users
//withdraw funds
//set a minimum funding value in usd

import {PriceConverter} from './PriceConverter.sol';
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    using PriceConverter for uint256;

    AggregatorV3Interface private s_priceFeed;
    uint256 public miniUsd=1e18;
    address public immutable i_owner;
    address[] private s_funders;
    mapping(address funder =>uint256 amount) private s_funderToAmount;
    
    constructor(address priceFeed){
        i_owner=msg.sender;
        s_priceFeed= AggregatorV3Interface(priceFeed);
    }

    function fund() public payable{
        require(msg.value.getConversionRate(s_priceFeed)>=miniUsd);
        s_funders.push(msg.sender);
        s_funderToAmount[msg.sender]=msg.value;
    }

    function withdraw() public onlyOwner{
        (bool success,)= payable(msg.sender).call{value:address(this).balance}('');
        require(success, 'withdraw failed');
        s_funders=new address[](0);
        for(uint256 i=0;i<s_funders.length;i++){
            address funderAddr = s_funders[i];
             s_funderToAmount[funderAddr]=0;
        }
    }

    function getVersion() public view returns(uint256) {
        return s_priceFeed.version();
    }

    modifier onlyOwner{
        require(i_owner==msg.sender);
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    // getters
    function getFunder(uint256 index) external view returns(address){
        return s_funders[index];
    }

    function getAddressToAmountFounded(address funderAddress) external view returns(uint256){
        return s_funderToAmount[funderAddress];
    }
      
    


}
