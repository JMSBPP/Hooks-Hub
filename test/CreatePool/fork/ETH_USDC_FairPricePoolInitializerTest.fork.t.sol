// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console2} from "forge-std/Test.sol";
import {Deployers} from "@uniswap/v4-core/test/utils/Deployers.sol";
import {ETH_USDC_FairPricePoolInitializer} from "../../../src/CreatePool/basic/hooks/ETH_USDC_FairPricePoolInitializer.sol";
import {ContractRegistry} from "flare-foundry-periphery-package/coston2/ContractRegistry.sol";
import {IWETH9} from "v4-periphery/src/interfaces/external/IWETH9.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";

contract ETH_USDC_FairPricePoolInitializerForkTest is Test, Deployers {
    // We are forking uniswap testnet and coston2 which is the testnet
    // for the flare network

    ///========UNICHAIN-TESTNET=========
    address constant POOL_MANAGER = 0x00B036B58a818B1BC34d502D3fE730Db729e62AC;
    address constant WETH = 0x4200000000000000000000000000000000000006;
    address constant USDC = 0x31d0220469e10c4E71834a79b1f276d740d3768F;
    //======COSTON2-TESTNET==========
    // The addresses are given by the ContractRegistry imported above
    bool forked;

    ///====ENV VARS
    uint256 costnotForkId;
    uint256 uinchainSepoliaForkId;
    address poolUser;

    ETH_USDC_FairPricePoolInitializer ethUsdcHook;
    function setUp() public {
        uint256 costnotForkId = vm.createFork(vm.rpcUrl("flare-coston2"));
        uint256 uinchainSepoliaForkId = vm.createFork(
            vm.rpcUrl("unichain_sepolia")
        );
        poolUser = vm.envAddress("DEVELOPER_ADDRESS");
        // The hook is on unichain but the price feed is on Coston.
        // QUESTION hOW TO ENABLE CROSS CHAI CALLS?
    }

    function switchToCoston2() internal {
        if (vm.activeFork() == unichainSepoliaForkId) {
            vm.selectFork(coston2ForkId);
        }
    }

    function switchToUnichain() internal {
        if (vm.activeFork() == coston2ForkId) {
            vm.selectFork(unichainSepoliaForkId);
        }
    }
}
