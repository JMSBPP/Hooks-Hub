// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "v4-periphery/src/utils/BaseHook.sol";
import {IBTC_USDC_FairPricePoolInitializer} from "../interfaces/IBTC_USDC_FairPricePoolInitializer.sol";
import {PoolId, PoolIdLibrary} from "@uniswap/v4-core/src/types/PoolId.sol";
import {BeforeSwapDeltaLibrary} from "@uniswap/v4-core/src/types/BeforeSwapDelta.sol";
import {Currency} from "@uniswap/v4-core/src/types/Currency.sol";
import {IBTC_USDC_DataFeed} from "../interfaces/IBTC_USDC_DataFeed.sol";
import {SqrtPriceSafeCast} from "../libraries/SqrtPriceSafeCast.sol";
// This Hooks enables the creation of a pool with fair price only
// It Only implements the `beforeInitialize` and `afterInitiaize`
// `beforeInialize` verifies that the pool has a external oracle
// `afterInitialize` sets the pool price to the external oracle

contract BTC_USDC_FairPricePoolInitializer is
    BaseHook,
    IBTC_USDC_FairPricePoolInitializer
{
    using PoolIdLibrary for PoolKey;
    using SqrtPriceSafeCast for uint256;

    IBTC_USDC_DataFeed priceFeed;
    bool initialized;

    address private WBTC;
    address private USDC;

    mapping(PoolId pool => bool isValidPool) private validPools;

    modifier onlyInitialized() {
        if (!initialized) revert NotInitialized();
        _;
    }

    modifier onlyValidPool(PoolKey calldata poolKey) {
        if (!validPools[poolKey.toId()]) revert InvalidPool();
        _;
    }
    constructor(IPoolManager _poolManager) BaseHook(_poolManager) {
        initialized = false;
    }

    function initialize(
        address _wbtc,
        address _usdc,
        IBTC_USDC_DataFeed _priceFeed
    ) external {
        WBTC = _wbtc;
        USDC = _usdc;
        priceFeed = _priceFeed;
        initialized = true;
    }

    function _beforeInitialize(
        address,
        PoolKey calldata poolKey,
        uint160 initialPrice
    ) internal virtual override onlyInitialized returns (bytes4) {
        // This checks that the is WBTC/USDC
        if (
            (Currency.unwrap(poolKey.currency0) != WBTC &&
                Currency.unwrap(poolKey.currency1) != USDC) ||
            (Currency.unwrap(poolKey.currency0) != USDC &&
                Currency.unwrap(poolKey.currency1) != WBTC)
        ) {
            revert InvalidPool__OnlyWBTC_USDCPoolAllowed();
        } else {
            (uint256 externalPrice, ) = priceFeed.get_BTC_USDC_Price_Wei();

            validPools[poolKey.toId()] = uint160(externalPrice) == initialPrice;
        }

        return IHooks.beforeInitialize.selector;
    }

    function _beforeAddLiquidity(
        address,
        PoolKey calldata poolKey,
        ModifyLiquidityParams calldata,
        bytes calldata
    )
        internal
        virtual
        override
        onlyInitialized
        onlyValidPool(poolKey)
        returns (bytes4)
    {
        return IHooks.beforeAddLiquidity.selector;
    }

    function _beforeSwap(
        address,
        PoolKey calldata poolKey,
        SwapParams calldata,
        bytes calldata
    )
        internal
        virtual
        override
        onlyInitialized
        onlyValidPool(poolKey)
        returns (bytes4, BeforeSwapDelta, uint24)
    {
        return (
            IHooks.beforeSwap.selector,
            BeforeSwapDeltaLibrary.ZERO_DELTA,
            uint24(0x00)
        );
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
                beforeAddLiquidity: true,
                afterAddLiquidity: false,
                beforeRemoveLiquidity: false,
                afterRemoveLiquidity: false,
                beforeSwap: true,
                afterSwap: false,
                beforeDonate: true,
                afterDonate: false,
                beforeSwapReturnDelta: false,
                afterSwapReturnDelta: false,
                afterAddLiquidityReturnDelta: false,
                afterRemoveLiquidityReturnDelta: false
            });
    }

    function getWTBC() external view onlyInitialized returns (address _wbtc) {
        return WBTC;
    }
    function getUSDC() external view onlyInitialized returns (address _usdc) {
        return USDC;
    }
}
