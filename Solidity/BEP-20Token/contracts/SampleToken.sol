// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./BEP20Burnable.sol";

contract SampleToken is BEP20Burnable {
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply
    ) BEP20(_name, _symbol) {
        _mint(_msgSender(), _totalSupply * (10**decimals()));
    }
}
