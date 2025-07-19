# HOOK FUNCTIONS WORKSHOP

## beforeInitialize

```solidity
function beforeInitialize(
    address sender,
    PoolKey calldata key,
    uint160 sqrtPriceX96
    ) external returns (bytes4);
```
- `beforeInitialize`  executes only at most once.r,
- the output of this function is not stored $\implies$  `beforeInitialize` **does
not affect the initial state of the pool**.
### Use Cases
- revert the entire pool creation based on conditional logic 
  -  hook to serve as a signal regarding the pool creation
following a particular process. In this case, the hook creator can include an auxiliary function in the hook code and follow the specific desired steps of pool creation within that function.
### Questions
- How this function can be integrated with `Initializable.sol` when the hook is meant to be upgradable to perform upgradability requirement checks?

## afterInitialize

The hook function after pool creation is named afterInitialize, also based on the convention
that pool creation is referred to as initialization. As with the beforeInitialize function, the
output for the afterInitialize function is not stored. Nonetheless, since the pool has been
created when the afterInitialize function executes, the afterInitialize function can nonetheless
modify state variables of the pool immediately after the pool has been created so long as
those state variables are accessible by the hook. Moreover, as a separate point, a practical use
of the afterInitialize function could be to take actions that would integrate the newly created
pool with other aspects of the cryptoeconomic ecosystem. For example, the afterInitialize
function could add the newly created pool to an open registry such as one that might be
used by an aggregator to source liquidity