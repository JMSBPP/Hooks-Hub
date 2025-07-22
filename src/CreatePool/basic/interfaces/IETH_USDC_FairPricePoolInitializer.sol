// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {IETH_USDC_DataFeed} from "./IETH_USDC_DataFeed.sol";
interface IETH_USDC_FairPricePoolInitializer {
    error NotInitialized();

    error InvalidPool__OnlyWETH_USDCPoolAllowed();

    error InvalidPool();
    function initialize(
        address _weth,
        address _usdc,
        IETH_USDC_DataFeed _priceFeed
    ) external;

    function getWETH() external view returns (address _weth);
    function getUSDC() external view returns (address _usdc);
}
