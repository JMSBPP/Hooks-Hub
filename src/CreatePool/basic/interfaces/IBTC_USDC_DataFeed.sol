// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

interface IBTC_USDC_DataFeed {
    function get_BTC_USDC_Price_Wei() external returns (uint256, uint64);
}
