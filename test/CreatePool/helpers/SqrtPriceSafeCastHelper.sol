// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {SqrtPriceSafeCast} from "../../../src/CreatePool/basic/libraries/SqrtPriceSafeCast.sol";
contract SqrtPriceSafeCastHelper {
    using SqrtPriceSafeCast for uint256;

    function safeCast(uint256 x) external pure returns (uint160 y) {
        y = x.safeCast();
    }
}
