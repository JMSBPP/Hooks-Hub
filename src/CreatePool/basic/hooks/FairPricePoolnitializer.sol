// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {PoolKey} from "v4-core/types/PoolKey.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";
import {BaseHook} from "v4-periphery/src/utils/BaseHook.sol";
import {Hooks} from "v4-core/libraries/Hooks.sol";
import {IHooks} from "v4-core/interfaces/IHooks.sol";

// This Hooks enables the creation of a pool with fair price only
// It Only implements the `beforeInitialize` and `afterInitiaize`
// `beforeInialize` verifies that the pool has a external oracle
// `afterInitialize` sets the pool price to the external oracle

contract BTC_USDC_FairPricePoolInitializer is BaseHook {
    constructor(IPoolManager _poolManager) BaseHook(_poolManager) {}

    function _beforeInitialize(
        address,
        PoolKey calldata,
        uint160
    ) internal virtual override returns (bytes4) {
        return IHooks.beforeInitialize.selector;
    }
    function _afterInitialize(
        address,
        PoolKey calldata,
        uint160,
        int24
    ) internal virtual override returns (bytes4) {
        return IHooks.afterInitialize.selector;
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
                afterInitialize: true,
                beforeAddLiquidity: false,
                afterAddLiquidity: false,
                beforeRemoveLiquidity: false,
                afterRemoveLiquidity: false,
                beforeSwap: false,
                afterSwap: false,
                beforeDonate: false,
                afterDonate: false,
                beforeSwapReturnDelta: false,
                afterSwapReturnDelta: false,
                afterAddLiquidityReturnDelta: false,
                afterRemoveLiquidityReturnDelta: false
            });
    }
}
