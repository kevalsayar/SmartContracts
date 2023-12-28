// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract FNFToken is Initializable, ERC20Upgradeable, OwnableUpgradeable {
    function initialize(
        string memory tokenName,
        string memory tokenSymbol
    ) public initializer {
        __ERC20_init(tokenName, tokenSymbol);
        __Ownable_init();
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function transfer(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {
        require(amount > 0, "Transfer amount must be greater than zero");
        _transfer(from, to, amount);
        return true;
    }
}
