// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.26;

interface IDummyContract {
    function computeSum(uint24 a) external pure returns (uint24 res);
}

contract DummyContract is IDummyContract {
    function computeSum(uint24 a) external pure returns (uint24 res) {
        res = a + 1;
    }
}
