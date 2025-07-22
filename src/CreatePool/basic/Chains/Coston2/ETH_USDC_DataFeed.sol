// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {ContractRegistry} from "flare-foundry-periphery-package/coston2/ContractRegistry.sol";
import {FtsoV2Interface} from "flare-foundry-periphery-package/coston2/FtsoV2Interface.sol";
import {IETH_USDC_DataFeed} from "../../interfaces/IETH_USDC_DataFeed.sol";
// This is the feed valid for coston2 testnet ONLY

contract ETH_USDC_DataFeed is IETH_USDC_DataFeed {
    bytes21 public constant ETH_USDC_PRICE_FEED_ID =
        bytes21(0x014554482f55534400000000000000000000000000);

    function get_ETH_USDC_Price_Wei() external returns (uint256, uint64) {
        FtsoV2Interface ftsoV2 = ContractRegistry.getFtsoV2();

        return ftsoV2.getFeedByIdInWei(ETH_USDC_PRICE_FEED_ID);
    }
}
