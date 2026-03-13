// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract GetFundMe is Script {
    function run() external view {
        address latestDeployment = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        console.log("Latest FundMe deployed at:", latestDeployment);
    }
}
