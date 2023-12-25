# Smart Contracts

[![npm](https://img.shields.io/npm/v/truffle.svg)](https://www.npmjs.com/package/truffle)
[![Truffle](https://img.shields.io/badge/Truffle-%5E5.0.0-brightgreen.svg)](https://www.trufflesuite.com/truffle)
[![Ganache](https://img.shields.io/badge/Ganache-Latest-brightgreen.svg)](https://github.com/trufflesuite/ganache)
[![MetaMask](https://img.shields.io/badge/MetaMask-Latest-brightgreen.svg)](https://metamask.io/)
[![Node.js](https://img.shields.io/badge/Node.js-%5E14.0.0-brightgreen.svg)](https://nodejs.org/)

## **Overview**

This repo contains of smart contracts, each serving a specific purpose in the blockchain ecosystem, brought to life using **Truffle**, which is a development environment, testing framework, and asset pipeline for Ethereum, aiming to make life as an Ethereum developer easier.

Note that these are made upgradeable with the help of **OpenZeppelin's Upgrades** library which mainly helps in deploying upgradeable contracts with automated security checks.

*Many more contracts are planned to be included soon!*

## **Contracts**

1. [BEP-20 Token](./contracts/escrow.sol): The BEP-20 token contract implements the standard token interface for the Binance Smart Chain. It includes features such as transfer, approval, and burning.

2. [BEP-20 Token Vesting](./contracts/tokenEscrow.sol): This contract facilitates the vesting of BEP-20 tokens over a specified period. It ensures that tokens are released gradually according to a predefined schedule.

3. [Escrow](./contracts/otherContract1.sol): The escrow contract acts as a trusted intermediary, holding funds until specific conditions are met. It provides a secure way to handle transactions between parties.

4. [Fractional NFTs](./contracts/otherContract2.sol): The fractional NFT contract allows the creation and management of fractional ownership of non-fungible tokens (NFTs). Users can buy and sell fractions of NFTs, enabling shared ownership.

## **Getting Started**

To understand each smart contract and its functionalities, refer to their individual README files in their individual directories:

- [BEP-20 Token](./BEP-20Token/README.md)
- [BEP-20 Token Vesting](./BEP-20TokenVesting/README.md)
- [Escrow](./escrow/README.md)
- [Fractional NFTs](./fractionalNFTs/README.md)
