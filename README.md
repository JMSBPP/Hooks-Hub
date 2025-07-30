

# Direct Swap


# Order Based
## 1 Inch Limit Order

### Off-Chain
- **Resolvers**
- **Order Creation Signatures**

### Definitions
- **Limit Order:**
```solidity
struct LimitOrder{
  SwapOrder swapOrder;
  bytes extensions;
}
```
  - **`extensions`:**
    - **external calls**
    - **deadlines**
    - **price ranges/limits**
### Flow
- `maker` creates an order
```solidity
struct Order {
    uint256 salt;
    Address maker;
    Address receiver;
    Address makerAsset;
    Address takerAsset;
    uint256 makingAmount;
    uint256 takingAmount;
    MakerTraits makerTraits;
}
```
- Additional data for all these functionalities resides in the order's extension - a separate pack of data accompanying the order. 

- It's not included in the "base" order struct but is cryptographically connected with the corresponding order via the `salt` parameter (which includes a hash of the extension contents). The extension is processed with the order and contains different types of additional data, like arguments for additional external calls.

- There is also a `TakerTraits` pack of order parameters, which is added by a **resolver** during the process of filling an order.

- The equivalent `beforeSwap/afterSwap` functionality is separated for `maker` and `taker`.

- For `maker` is done through the `IPreInteraction/beforeSwap, IPostInteraction/afterSwap` which is excecutable only if enabled in `MakerTraits`

- For `taker` is done through the `ITakerInteraction/beforeSwap, afterSwap`


