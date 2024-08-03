// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test{
    FundMe fundme;
    function setUp() external {
        fundme=new FundMe();
    }

    function testMiniUsdIsOne() public view {
        assertEq(fundme.miniUsd(),1e18);      
    } 
}