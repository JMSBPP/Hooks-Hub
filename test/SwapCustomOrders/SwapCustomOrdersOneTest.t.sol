// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Test, console2} from "forge-std/Test.sol";
import {Deployers} from "@uniswap/v4-core/test/utils/Deployers.sol";
import {HookMiner} from "v4-periphery/src/utils/HookMiner.sol";
import {SwapCustomOrdersOne} from "../../src/SwapCustomOrders/SwapCustomOrdersOne.sol";
import {Constants} from "@uniswap/v4-core/test/utils/Constants.sol";
import {IHooks} from "v4-core/interfaces/IHooks.sol";
import {Hooks} from "v4-core/libraries/Hooks.sol";
// ==> This can be helpful !
import {SwapHelperTest} from "@uniswap/v4-core/test/utils/SwapHelper.t.sol";
import {BalanceDelta} from "v4-core/types/BalanceDelta.sol";
import {PoolSwapTest} from "v4-core/test/PoolSwapTest.sol";

contract SwapCustomOrdersOneTest is Test, Deployers {
    using HookMiner for address;

    SwapCustomOrdersOne public solutionHook;
    SwapHelperTest public swapHelper;

    function setUp() public {
        swapHelper = new SwapHelperTest();
        deployFreshManagerAndRouters();
        (currency0, currency1) = deployMintAndApprove2Currencies();
        address solutionHookAddress = address(
            uint160(
                (type(uint160).max & clearAllHookPermissionsMask) |
                    Hooks.BEFORE_INITIALIZE_FLAG |
                    Hooks.BEFORE_SWAP_FLAG |
                    Hooks.AFTER_SWAP_FLAG
            )
        );

        solutionHook = SwapCustomOrdersOne(solutionHookAddress);
        deployCodeTo(
            "SwapCustomOrdersOne",
            abi.encode(manager),
            solutionHookAddress
        );
        (key, ) = initPoolAndAddLiquidity(
            currency0,
            currency1,
            IHooks(address(solutionHook)),
            Constants.FEE_MEDIUM,
            SQRT_PRICE_1_2 + 1
        );
    }

    function test__swap() external {
        BalanceDelta res = swapRouter.swap(
            key,
            SWAP_PARAMS,
            PoolSwapTest.TestSettings({
                takeClaims: false,
                settleUsingBurn: false
            }),
            Constants.ZERO_BYTES
        );
    }
}
