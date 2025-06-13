// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";
import {PoolManager} from "v4-core/PoolManager.sol";
import {IPoolManager} from "v4-core/interfaces/IPoolManager.sol";
import "./context/UnlockCallback.sol";

contract UnlockTest is Test {
    address private initalOwner = address(123);
    IPoolManager private poolManager;
    IDummyContract private dummyContract;
    IUnlockCallback private unlockCallback;

    function setUp() public {
        poolManager = new PoolManager(initalOwner);
        dummyContract = new DummyContract();
        unlockCallback = new UnlockCallback(address(dummyContract));
    }

    function testShouldReturnTwo() external returns (uint24 decRes) {
        vm.startPrank(initalOwner);
        bytes memory correctData = abi.encodePacked(address(dummyContract));
        bytes memory result = poolManager.unlock(correctData);
        decRes = abi.decode(result, (uint24));
        vm.stopPrank();
    }
}
