// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Solution, SOLUTION_SLOT, SolutionLibrary} from "../types/Solution.sol";
import {SwapParams} from "v4-core/types/PoolOperation.sol";
contract SolutionLibraryHelper {
    using SolutionLibrary for SwapParams;
    using SolutionLibrary for Solution;
    using SolutionLibrary for bytes32;
}
