// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Test, console2} from "forge-std/Test.sol";
import {SolutionLibraryHelper, SolutionLibrary} from "../../src/SwapCustomOrders/helper/SolutionLibraryHelper.sol";
import {Deployers} from "@uniswap/v4-core/test/utils/Deployers.sol";
import {SwapParams} from "v4-core/types/PoolOperation.sol";

contract SolutionLibraryTest is Test, Deployers {
    SolutionLibraryHelper helper;
    function setUp() public {
        helper = new SolutionLibraryHelper();
    }

    function test__solution() external {
        string memory solution = helper.getSolution(SWAP_PARAMS);
        console2.log(solution);
        bytes32 packedSolution = helper.toBytes32(solution);
        console2.logBytes32(packedSolution);
        string memory unpackedSolution = helper.toString(packedSolution);
        console2.log(unpackedSolution);
    }
}
