//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.1 ether;

    function fundFundMe(address mostRecentlyDeployed) public {
        vm.deal(msg.sender, SEND_VALUE);
        vm.startBroadcast();
        FundMe fundMe = FundMe(payable(mostRecentlyDeployed));
        fundMe.fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Funded FundMe with 's'", SEND_VALUE);
    }

    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        fundFundMe(mostRecentDeployed);
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe fundMe = FundMe(payable(mostRecentlyDeployed));
        fundMe.withdraw();
        vm.stopBroadcast();
        console.log("Withdrew from FundMe");
    }

    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        withdrawFundMe(mostRecentDeployed);
    }
}
