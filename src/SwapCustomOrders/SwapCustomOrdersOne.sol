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
//                \              |<0 | -> "P_{WETH/USDC} = 1/P_{USDC/WETH}"
//                 \             /
//                  \           /
//            "I am depositing {USDC}"
//                              \
//                               \
//                              |->0| -> "I want to buy exactly {amountSpecified} ETH"

//
//          if (zeroForOne) {
//             if (params.sqrtPriceLimitX96 >= slot0Start.sqrtPriceX96()) {

// This can be solved by looking at the swap flow on Pool.sol
//                 PriceLimitAlreadyExceeded.selector.revertWith(slot0Start.sqrtPriceX96(), params.sqrtPriceLimitX96);
//             }
// ==> max(P_y/x) >= P_y/x

//             // Swaps can never occur at MIN_TICK, only at MIN_TICK + 1, except at initialization of a pool
//             // Under certain circumstances outlined below, the tick will preemptively reach MIN_TICK without swapping there
//             if (params.sqrtPriceLimitX96 <= TickMath.MIN_SQRT_PRICE) {
//                 PriceLimitOutOfBounds.selector.revertWith(params.sqrtPriceLimitX96);
//             }
//         } else {
//             if (params.sqrtPriceLimitX96 <= slot0Start.sqrtPriceX96()) {
//                 PriceLimitAlreadyExceeded.selector.revertWith(slot0Start.sqrtPriceX96(), params.sqrtPriceLimitX96);
//             }
