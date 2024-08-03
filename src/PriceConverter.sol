// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice(AggregatorV3Interface priceFeed) internal view returns(uint256){
        (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        return uint256(answer*1e10);
    }

    function getConversionRate(uint256 ethToUsdamount,AggregatorV3Interface priceFeed) internal view returns(uint256) {
        uint256 conversionRate= getPrice(priceFeed);
        return (conversionRate*ethToUsdamount)/1e18;
    }
}