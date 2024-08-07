// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interaction.s.sol";

contract FundMeTestInteraction is Test {
    FundMe fundMe;
    address USER = makeAddr('user');
    uint256 constant STARTING_BALNACE=50 ether;
    uint256 constant SEND_VALUE=0.1 ether;
    uint256 constant GAS_PRICE=1;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe=deployFundMe.run();
        vm.deal(USER,STARTING_BALNACE);
    }

    function testUserCanFundInteraction() public {
        FundFundMe fundFundMe=new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        address funder= fundMe.getFunder(0);
        assertEq(funder,USER);
    }

    function testUserCanWithdrawInteraction() public {
        FundFundMe fundFundMe=new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawFundMe=new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assertEq(address(fundMe).balance,0);
    }
}