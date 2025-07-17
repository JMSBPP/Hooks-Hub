// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Test, console2} from "forge-std/Test.sol";
import {Deployers} from "@uniswap/v4-core/test/utils/Deployers.sol";
import {HookMiner} from "v4-periphery/src/utils/HookMiner.sol";
import {SwapCustomOrdersOne, SolutionStorage} from "../../src/SwapCustomOrders/SwapCustomOrdersOne.sol";
import {Constants} from "@uniswap/v4-core/test/utils/Constants.sol";

// ==> This can be helpful !
import {SwapHelperTest} from "@uniswap/v4-core/test/utils/SwapHelper.t.sol";

contract SwapCustomOrdersOneTest is Test, Deployers {
    using HookMiner for address;

    SwapCustomOrdersOne public solutionHook;
    SolutionStorage public solutionStorage;
    SwapHelperTest public swapHelper;

    function setUp() public {
        swapHelper = new SwapHelperTest();
        address solutionHookAddress = address(this).computeAddress(
            Constants.MAX_UINT256,
            type(SwapCustomOrdersOne).creationCode
        );
        solutionStorage = new SolutionStorage();
        solutionHook = SwapCustomOrdersOne(solutionHookAddress);
        deployCodeTo(
            "SwapCustomOrdersOne",
            abi.encode(manager, solutionStorage),
            solutionHookAddress
        );
    }
}
