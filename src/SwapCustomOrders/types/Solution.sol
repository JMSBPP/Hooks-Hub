// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {SwapParams} from "v4-core/types/PoolOperation.sol";

error SolutionHasNotBeenInitialized();
library SolutionLibrary {
    // keccak256("uniswap.v4.hooks.swapcustomordersone.solution")
    bytes32 public constant SOLUTION_SLOT =
        0x9ea3ce550c218fed9dcc116178371cec492c6c93777656698bf3df701f5edc73;
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
    ) internal pure returns (string memory _solution) {
        if (swapParams.zeroForOne) {
            if (swapParams.amountSpecified < 0) {
                _solution = "sell exactly amountSpec ETH";
            } else if (swapParams.amountSpecified > 0) {
                _solution = "buy exactly amountSpec USDC";
            }
        } else {
            if (swapParams.amountSpecified < 0) {
                _solution = "sell exactly amountSpec USDC";
            } else if (swapParams.amountSpecified > 0) {
                _solution = "buy exactly amountSpec ETH";
            }
        }
    }
    function toBytes32(
        string memory _solution
    ) internal pure returns (bytes32 packedSolution) {
        bytes memory temp = bytes(_solution);
        if (temp.length == 0) {
            return 0x0;
        }
        assembly {
            packedSolution := mload(add(_solution, 32))
        }
    }
    function toString(
        bytes32 packedSolution
    ) internal pure returns (string memory _solution) {
        unchecked {
            uint256 start = 0;
            uint256 end = 32;
            for (; start < 32; start++) {
                if (uint8(packedSolution[start]) != 0) {
                    break;
                }
            }

            for (; end > start; end--) {
                if (uint8(packedSolution[end - 1]) != 0) {
                    break;
                }
            }
            uint256 len = end > start ? end - start : 0;
            if (len == 0) return "";
            bytes memory result = new bytes(len);
            for (uint256 i = 0; i < len; i++) {
                result[i] = packedSolution[start + i];
            }
            _solution = string(result);
        }
    }
    function store(bytes32 packedSolution) internal {
        assembly ("memory-safe") {
            tstore(SOLUTION_SLOT, packedSolution)
        }
    }

    function load() internal returns (bytes32) {
        assembly ("memory-safe") {
            mstore(0, tload(SOLUTION_SLOT))
            return(0, 0x20)
        }
    }

    // function isInitialized(
    //     Solution memory _solution
    // ) internal pure returns (bool) {
    //     return _solution.savedSlot == bytes32(0) && SOLUTION_SLOT != bytes32(0);
    // }

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
