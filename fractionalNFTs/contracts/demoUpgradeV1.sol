// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract DemoUpgradeV1 {
    address public walletAddress;
    uint256 public randomNumber;

    function setAddress(uint256 _randomNumber) public {
        walletAddress = msg.sender;
        randomNumber = _randomNumber;
    }
}
