// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script,console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE=0.1 ether;
    address USER= makeAddr("user");

    function fundFundMe(address mostRecentDeployed) public {
        vm.prank(USER);
        vm.deal(USER,SEND_VALUE);
        FundMe(payable(mostRecentDeployed)).fund{value:SEND_VALUE}();       
        console.log("Funded FundMe with %s",SEND_VALUE);
    }

    function run()  external {
        address mostRecentDeployed=DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);
        vm.startBroadcast();
        fundFundMe(mostRecentDeployed);
        vm.stopBroadcast();
    }
    
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecentDeployed) public {
        vm.startBroadcast();   
        FundMe(payable(mostRecentDeployed)).withdraw();
        vm.stopBroadcast();       
    }

    function run() external {
        address mostRecentDeployed=DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);
        vm.startBroadcast();
        WithdrawFundMe(mostRecentDeployed);
        vm.stopBroadcast();
    }
    
}

