// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract DemoUpgrade {
    address public walletAddress;

    function setAddress() public {
        walletAddress = msg.sender;
    }
}
