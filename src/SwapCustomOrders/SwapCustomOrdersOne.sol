// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

// 1. Create a hook that only accepts USDC and ETH and console logs a string describing the operation
// made by the swapper
// Then implement unit and fork testing to validate that the operation was indeed what the log says
// > BONUS perform tests using runTimeVerification locker
///=====ANSWER=====
// The swapOperations are defined by the SwapParams on PoolOperation
/// @notice Parameter struct for `Swap` pool operations
// struct SwapParams {
//     /// Whether to swap token0 for token1 or vice versa
//     bool zeroForOne;
//     /// The desired input amount if negative (exactIn), or the desired output amount if positive (exactOut)
//     int256 amountSpecified;
//     /// The sqrt price at which, if reached, the swap will stop executing
//     uint160 sqrtPriceLimitX96;
// }
//1. The order is WETH/USDC given the fact that ETH is zero
//
//
//                                |<0 | -> "I want to sell exactly {amountSpecified} ETH"
//                                 /
//                                /
//               "I am depositing {WETH}
//                 /              \
//     WETH/USDC  /                \
// ==> zeroForOne                 |>0| -> "I want to buy exactly {amountSpecified} USDC"
//               \
//                \              |<0 | -> "I want to sell exactly {amountSpecified} USDC"
//                 \             /
//                  \           /
//            "I am depositing {USDC}"
//                              \
//                               \
//                              |->0| -> "I want to buy exactly {amountSpecified} ETH"
//
// 2. Now we need to look at the price meaning of the swap
// notice one of the SwapParams is the sqrtPriceLimitX96
// But is it pricing ETH for USD or USD for ETH?

//                                |<0 | -> "P_{USDC/WETH} -> How much USDC do I get for {amountSpecified} ETH?"
//                                 /
//                                /
//               "I am depositing {WETH}
//                 /              \
//     WETH/USDC  /                \
// ==> zeroForOne                 |>0| -> "P_{USDC/WETH} -> How many ETH do I need to deposit buying exactly {amountSpecified} USDC"
//               \
//                \              |<0 | -> "P_{WETH/USDC} = 1/P_{USDC/WETH}
//                                                       -> How much ETH do I get for {amountSpecified} USDC?"
//                 \             /
//                  \           /
//            "I am depositing {USDC}"
//                              \
//                               \
//                              |->0| -> "P_{WETH/USDC} = 1/P_{USDC/WETH}
//                                                      -> How many USDC do I need to deposit buying exactly {amountSpecified} ETH?"

// The above assertions can bee seen on the Pool.sol, swap flow:
//          if (zeroForOne) {
//             if (params.sqrtPriceLimitX96 >= slot0Start.sqrtPriceX96()) {
//                 PriceLimitAlreadyExceeded.selector.revertWith(slot0Start.sqrtPriceX96(), params.sqrtPriceLimitX96);
//              }
//            < = >
//               if( MAX (P_{USDC/WETH}) >= P_{USDC/WETH} ) {
//                  PriceLimitAlreadyExceeded.selector.revertWith(slot0Start.sqrtPriceX96(), params.sqrtPriceLimitX96);
//               }

//             if (params.sqrtPriceLimitX96 <= TickMath.MIN_SQRT_PRICE) {
//                 PriceLimitOutOfBounds.selector.revertWith(params.sqrtPriceLimitX96);
//             }
//         < = >
//               if( MAX (P_{USDC/WETH}) <= 1/P_{USDC/WETH} ) {
//         < = >     MAX (P_{USDC/WETH}) <= P_{WETH/USDC}
//                  PriceLimitAlreadyExceeded.selector.revertWith(slot0Start.sqrtPriceX96(), params.sqrtPriceLimitX96);
//               }
import {BaseHook} from "v4-periphery/src/utils/BaseHook.sol";
import {IPoolManager} from "v4-core/interfaces/IPoolManager.sol";
import {IHooks} from "v4-core/interfaces/IHooks.sol";
import {Hooks} from "v4-core/libraries/Hooks.sol";
import {PoolKey} from "v4-core/types/PoolKey.sol";
import {SwapParams} from "v4-core/types/PoolOperation.sol";
import {BalanceDelta, BalanceDeltaLibrary} from "v4-core/types/BalanceDelta.sol";
import {BeforeSwapDelta, BeforeSwapDeltaLibrary} from "v4-core/types/BeforeSwapDelta.sol";
import {Constants} from "@uniswap/v4-core/test/utils/Constants.sol";
import {SolutionLibrary} from "./types/Solution.sol";

contract SwapCustomOrdersOne is BaseHook {
    using BalanceDeltaLibrary for BalanceDelta;
    using SolutionLibrary for SwapParams;
    using SolutionLibrary for string;
    using SolutionLibrary for bytes32;
    event AnswerBeforeSwap(string _solution);
    event AnswerAfterSwap(string _solution);

    constructor(IPoolManager _manager) BaseHook(_manager) {}
    function _beforeInitialize(
        address,
        PoolKey calldata,
        uint160
    ) internal virtual override returns (bytes4) {
        // TODO: Check that WETH is token0 and USDC is token1
        // TODO: Not allow any pools other than WETH/USDC
        return IHooks.beforeInitialize.selector;
    }
    function _beforeSwap(
        address,
        PoolKey calldata,
        SwapParams calldata swapParams,
        bytes calldata
    ) internal virtual override returns (bytes4, BeforeSwapDelta, uint24) {
        string memory _solution = swapParams.getSolution();
        _solution.toBytes32().store();
        emit AnswerBeforeSwap(_solution);
        return (
            IHooks.beforeSwap.selector,
            BeforeSwapDeltaLibrary.ZERO_DELTA,
            Constants.FEE_MEDIUM
        );
    }

    function _afterSwap(
        address,
        PoolKey calldata,
        SwapParams calldata,
        BalanceDelta,
        bytes calldata
    ) internal virtual override returns (bytes4, int128) {
        // TODO: This function verifies if what said
        // on beforeSwap on the deltas is true
        // 1- Reads the solution from the transient storage
        string memory _solution = SolutionLibrary.load().toString();
        emit AnswerAfterSwap(_solution);
        return (IHooks.afterSwap.selector, 0);
    }

    function getHookPermissions()
        public
        pure
        virtual
        override
        returns (Hooks.Permissions memory)
    {
        return
            Hooks.Permissions({
                beforeInitialize: true,
                afterInitialize: false,
                beforeAddLiquidity: false,
                afterAddLiquidity: false,
                beforeRemoveLiquidity: false,
                afterRemoveLiquidity: false,
                beforeSwap: true,
                afterSwap: true,
                beforeDonate: false,
                afterDonate: false,
                beforeSwapReturnDelta: false,
                afterSwapReturnDelta: false,
                afterAddLiquidityReturnDelta: false,
                afterRemoveLiquidityReturnDelta: false
            });
    }
}
