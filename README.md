# Workshop

For each of the excercises present a `hookName.md` with answering the following questions

- **Question 1:** How many pools can call into this hook?
  - One-Pool Only
  - Non-Explicit Multiple-Pool Support
- **Question 2:** Does this hook initiate calls to the PoolManager?
  - On unlockCallback Data
  - Skipped Callbacks
  
- **Question 3:** Does this hook call modifyLiquidity?
  - Hooks That Own Positions
  - Hooks That Mint Shares

- **Question 4:** Do the swap callbacks exhibit some kind of symmetry?
  - Custom Swapping Logic

- **Question 5:** Does this hook support native tokens?

- **Question 6:** How is Access Control Implemented in Your Hook?

  - Caller Verification and Hook Permissions
  - Protecting Sensitive Functions
  - Configuration and Upgradability


## Create Custom Orders
- Create a hook that only accepts pools of USDC/WETH and the only
available operation is swapping WETH for USDC when the price is
between 3000 - 3500


