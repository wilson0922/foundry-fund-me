// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test{
    FundMe fundMe;
    address USER = makeAddr('user');
    uint256 STARTING_BALNACE=50 ether;

    function setUp() external {
        DeployFundMe deployFundMe=new DeployFundMe();
        fundMe=deployFundMe.run();
        vm.deal(USER,STARTING_BALNACE);
    }

    function testMiniUsdIsOne() public view {
        assertEq(fundMe.miniUsd(),1e18);      
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.i_owner(),msg.sender);  
    }

    function testGetVersion() public view {
        uint256 version=fundMe.getVersion();
        assertEq(version,0);
    }

    function testWithoutEnoughEth() public {
        vm.expectRevert();
        fundMe.fund{value:0}();
    }

    function testFundUpdateFundedDataStructure() public {
        vm.prank(USER);
        fundMe.fund{value: 0.1 ether}();
        uint256 amountFunded=fundMe.getAddressToAmountFounded(USER);
        assertEq(amountFunded,0.1 ether);
    }


}