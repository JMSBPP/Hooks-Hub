// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {SwapParams} from "v4-core/types/PoolOperation.sol";

struct Solution {
    string solution;
    bytes32 savedSlot;
}

bytes32 constant SOLUTION_SLOT = keccak256(
    "uniswap.v4.hooks.swapcustomordersone.solution"
);

error SolutionHasNotBeenInitialized();
library SolutionLibrary {
    using SolutionLibrary for Solution;
    //                                |<0 | -> "sell exactly amountSpec ETH"
    //                                 /
    //                                /
    //               "I am depositing {WETH}
    //                 /              \
    //     WETH/USDC  /                \
    // ==> zeroForOne                 |>0| -> "buy exactly amountSpec USDC"
    //               \
    //                \              |<0 | -> "sell exactly amountSpec USDC"
    //                 \             /
    //                  \           /
    //            "I am depositing {USDC}"
    //                              \
    //                               \
    //                              |->0| -> "buy exactly amountSpec ETH"
    function getSolution(
        SwapParams memory swapParams
    ) internal pure returns (Solution memory _solution) {
        _solution.savedSlot = SOLUTION_SLOT;
        if (swapParams.zeroForOne) {
            if (swapParams.amountSpecified < 0) {
                _solution.solution = "sell exactly amountSpec ETH";
            } else if (swapParams.amountSpecified > 0) {
                _solution.solution = "buy exactly amountSpec USDC";
            }
        } else {
            if (swapParams.amountSpecified < 0) {
                _solution.solution = "sell exactly amountSpec USDC";
            } else if (swapParams.amountSpecified > 0) {
                _solution.solution = "buy exactly amountSpec ETH";
            }
        }
    }

    function isInitialized(
        Solution memory _solution
    ) internal pure returns (bool) {
        return SOLUTION_SLOT != bytes32(0);
    }

    // function read(
    //     bytes32 packedSolution
    // ) internal view returns (Solution memory _solution) {
    //     _solution = abi.decode(packedSolution, (Solution));
    // }

    // function save(Solution memory _solution) internal {
    //     if (!_solution.isInitialized()) revert SolutionHasNotBeenInitialized();
    //     bytes32 packedSolution = abi.encodePacked(_solution.solution);
    //     assembly ("memory-safe") {
    //         tstore(_solution.savedSlot, packedSolution)
    //     }
    // }

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
}
