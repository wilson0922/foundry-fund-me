// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test{
    FundMe fundMe;
    address USER = makeAddr('user');
    uint256 constant STARTING_BALNACE=50 ether;
    uint256 constant SEND_VALUE=0.1 ether;
    uint256 constant GAS_PRICE=1;

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

    function testFundUpdateFundedDataStructure() public funded {
        uint256 amountFunded=fundMe.getAddressToAmountFounded(USER);
        assertEq(amountFunded,SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public funded{
        address funder= fundMe.getFunder(0);
        assertEq(funder,USER);
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithSingleFunder() public funded {
        // arrage
        uint256 startingOwnerBal= fundMe.getOwner().balance;
        uint256 startingFundMeBal=address(fundMe).balance;

        // act
        address owner=fundMe.getOwner();
        vm.prank(owner);
        fundMe.withdraw();

        uint256 endingOwnerBal= fundMe.getOwner().balance;
        uint256 endingFundMeBal= address(fundMe).balance;

        // assert
        assertEq(endingFundMeBal,0);
        assertEq(startingOwnerBal+startingFundMeBal,endingOwnerBal);

    }

    function testWithdrawMultiFunders() public {
        // arrage
        uint160 numOfFunders=3;
        uint160 startingFunderIndex=1;

        for(uint160 i=startingFunderIndex; i<=numOfFunders; i++ ){
            hoax(address(i),SEND_VALUE);
            fundMe.fund{value:SEND_VALUE}();
        }

        uint256 startingOwnerBal= fundMe.getOwner().balance;
        uint256 startingFundMeBal=address(fundMe).balance;

        // act
        address owner=fundMe.getOwner();
        vm.prank(owner);
        fundMe.withdraw();

        uint256 endingOwnerBal= fundMe.getOwner().balance;
        uint256 endingFundMeBal= address(fundMe).balance;

        // assert
        assertEq(endingFundMeBal,0);
        assertEq(startingOwnerBal+startingFundMeBal,endingOwnerBal);

    }

    function testWithdrawMultiFundersCheaper() public {
        // arrage
        uint160 numOfFunders=3;
        uint160 startingFunderIndex=1;

        for(uint160 i=startingFunderIndex; i<=numOfFunders; i++ ){
            hoax(address(i),SEND_VALUE);
            fundMe.fund{value:SEND_VALUE}();
        }

        uint256 startingOwnerBal= fundMe.getOwner().balance;
        uint256 startingFundMeBal=address(fundMe).balance;

        // act
        address owner=fundMe.getOwner();
        vm.prank(owner);
        fundMe.cheaperWithdraw();

        uint256 endingOwnerBal= fundMe.getOwner().balance;
        uint256 endingFundMeBal= address(fundMe).balance;

        // assert
        assertEq(endingFundMeBal,0);
        assertEq(startingOwnerBal+startingFundMeBal,endingOwnerBal);

    }

    modifier funded {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

}