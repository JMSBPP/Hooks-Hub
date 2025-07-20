// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {ContractRegistry} from "flare-foundry-periphery-package/coston2/ContractRegistry.sol";
import {FtsoV2Interface} from "flare-foundry-periphery-package/coston2/FtsoV2Interface.sol";
import {IBTC_USDC_DataFeed} from "../../interfaces/IBTC_USDC_DataFeed.sol";
// This is the feed valid for coston2 testnet ONLY

contract BTC_USDC_DataFeed is IBTC_USDC_DataFeed {
    bytes21 public constant BTC_USDC_PRICE_FEED_ID =
        bytes21(0x014254432f55534400000000000000000000000000);

    function get_BTC_USDC_Price_Wei() external returns (uint256, uint64) {
        FtsoV2Interface ftsoV2 = ContractRegistry.getFtsoV2();

        return ftsoV2.getFeedByIdInWei(BTC_USDC_PRICE_FEED_ID);
    }
}
