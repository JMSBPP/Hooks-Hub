// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {SolutionLibrary} from "../types/Solution.sol";
import {SwapParams} from "v4-core/types/PoolOperation.sol";
contract SolutionLibraryHelper {
    using SolutionLibrary for SwapParams;
    using SolutionLibrary for bytes32;
    using SolutionLibrary for string;

    function getSolution(
        SwapParams memory swapParams
    ) external pure returns (string memory _solution) {
        return swapParams.getSolution();
    }
    function toBytes32(
        string memory _solution
    ) external pure returns (bytes32 packedSolution) {
        return _solution.toBytes32();
    }
    function toString(
        bytes32 packedSolution
    ) external pure returns (string memory _solution) {
        return packedSolution.toString();
    }

    // function isInitialized(
    //     Solution memory _solution
    // ) external pure returns (bool) {
    //     return _solution.isInitialized();
    // }
}
