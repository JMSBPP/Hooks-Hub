// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

interface IETH_USDC_DataFeed {
    function get_ETH_USDC_Price_Wei() external returns (uint256, uint64);
}
