// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {IBTC_USDC_DataFeed} from "./IBTC_USDC_DataFeed.sol";
interface IBTC_USDC_FairPricePoolInitializer {
    error NotInitialized();

    error InvalidPool__OnlyWBTC_USDCPoolAllowed();

    error InvalidPool();
    function initialize(
        address _wbtc,
        address _usdc,
        IBTC_USDC_DataFeed _priceFeed
    ) external;

    function getWTBC() external view returns (address _wbtc);
    function getUSDC() external view returns (address _usdc);
}
