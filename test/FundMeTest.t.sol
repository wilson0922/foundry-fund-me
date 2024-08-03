// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test{
    FundMe fundMe;
    function setUp() external {
        fundMe=new FundMe();
    }

    function testMiniUsdIsOne() public view {
        assertEq(fundMe.miniUsd(),1e18);      
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.i_owner(),address(this));  
    }

    function testGetVersion() public view {
        uint256 version=fundMe.getVersion();
        assertEq(version,4);
    }
}