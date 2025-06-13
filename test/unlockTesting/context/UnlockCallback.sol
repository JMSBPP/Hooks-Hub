// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.26;

import {IUnlockCallback} from "v4-core/interfaces/callback/IUnlockCallback.sol";
import "./dummyContract.sol";

contract UnlockCallback is IUnlockCallback {
    address private dummyContractAddress;

    enum Initialized {
        UNINITIALIZED,
        INITIALIZED
    }

    Initialized private _initialized = Initialized.UNINITIALIZED;
    error NotInitialized();
    constructor(address _dummyContractAddress) {
        dummyContractAddress = _dummyContractAddress;
        _initialized = Initialized.INITIALIZED;
    }

    function unlockCallback(
        bytes calldata data
    ) external returns (bytes memory) {
        if (_initialized != Initialized.INITIALIZED) revert NotInitialized();
        address decodedData = abi.decode(data, (address));
        if (dummyContractAddress == decodedData) {
            (, bytes memory res) = dummyContractAddress.call(
                abi.encodeWithSignature("computeSum(uint24)", 1)
            );
            return res;
        } else {
            return bytes("");
        }
    }
}
