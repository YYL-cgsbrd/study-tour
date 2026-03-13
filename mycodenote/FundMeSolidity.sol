//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice() internal view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF);
        (, int price, , , ) = priceFeed.latestRoundData();
        return uint256(price * 1e10);
    }

    function getConversionRate(uint256 ethAmount) internal view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    } 

    function getVersion() internal view returns (uint256) {
        return AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF).version();
    }
}

error notOwner();

contract FundMe {
    using PriceConverter for uint256;
    
    uint256 public constant MINIMUM_USD = 5e18;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFeeded;

    address public immutable owner;

    constructor() {
        owner = msg.sender;
    }

    function fund() public payable {
        require(msg.value.getConversionRate() >= MINIMUM_USD, "didn't send enough eth");
        funders.push(msg.sender);
        addressToAmountFeeded[msg.sender] += msg.value;
    }

    function withdraw() public payable onlyOwner {
        for(uint256 fundIndex = 0; fundIndex < funders.length; fundIndex ++) {
            address funder = funders[fundIndex];
            addressToAmountFeeded[funder] = 0;
        }
        funders = new address[](0);
        (bool callsuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callsuccess, "call failed!");
    }

    modifier onlyOwner() {
        //require(msg.sender == owner, "Must be owner!");
        if(owner != msg.sender){revert notOwner();}
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
