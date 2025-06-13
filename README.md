# ERC6909

```json
{
    "purpose": "manage multiple ERC20 tokens under the same contract",
    "requirements":[
        {
            "requirement": "Allowance-operator permission scheme",
            "description": "enable control over token approvals"
        }
    ]
}
```
- Providers _balance modifications_ through _mint_ and _burn_ operations.

- Token deposits from **swappers** and/or **liquidity providers** are _stored_ on the `PoolManager`.

## `PoolManager` as a client of `ERC6909`

- `PoolManager` _mints_ `ERC6909` tokens representing _claim_ of _balances_
- `user: = lp/swapper` _burns_ `ERC6909` tokens representing _paying_ `PoolManager` to _settle balances_.

```solidity
// ERC-20
IERC20(tokenA).transferFrom(owner, poolManager, amount);

// ERC-6909
poolManager.burn(owner, Currency.wrap(tokenA).toId(), amount);

```
## Servers:

### Spender:
- An account that transfers tokens on behalf of amother account


### Operator

- An account that has unlimited _transfer_ permissions on **ALL** `tokenId`'s for another account

## Sevices


### `mint`
- Creation of amount tokens

### `burn`

- Removal of amount tokens

