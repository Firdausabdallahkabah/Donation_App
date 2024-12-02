// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

interface AggregatorV3Interface {
    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint168 answeredInRound
        );
}

library PriceConverter {
    function getPrice() internal view returns (uint256) {
        AggregatorV3Interface pricefeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        (, int256 price, , , ) = pricefeed.latestRoundData();

        return uint256(price * 1e10); // adjust to 18 decimal numbers
    }

    function getConversionRate(uint256 ethAmount)
        internal
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice(); // adjust to 18 decimal numbers. AggregatorV3Interface 0x694AA1769357215DE4FAC081bf1f309aDC325306
        return (ethPrice * ethAmount) / 1e18;
    }
}
