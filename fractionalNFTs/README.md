# Fractional NFTs Smart Contract

## Overview

This directory contains the source code and documentation for the Fractional NFTs smart contract. The Fractional NFTs contract enables the fractionalization of Non-Fungible Tokens, allowing users to own and trade fractions of high-value NFTs.

## Fractional NFTs Contract Features

- **Supported Networks:** Binance Smart Chain (BSC)
- **Fractionalization:** Enable users to own fractions of NFTs
- **Governance:** Governance token for decision-making
- **Liquidity Pool:** Facilitate trading of fractionalized NFTs

## Smart Contract Details

- **Contract Name:** fNFT.sol
- **Network:** Mumbai Testnet (Polygon)
- **Version:** 1.0.0

## Table of Contents

1. [Getting Started](#getting-started)
   - [Prerequisites](#prerequisites)
   - [Installation](#installation)
2. [Usage](#usage)
   - [Deploying Contracts](#deploying-contracts)
3. [Testing](#testing)
4. [Examples](#examples)

## **Getting Started**

To deploy and interact with the fractionalNFTs smart contract, follow the steps below:

## **Prerequisites**

Ensure you have the following tools installed:

- [Node.js](https://nodejs.org/) and [npm](https://www.npmjs.com/).
- [Truffle](https://www.trufflesuite.com/truffle) for contract deployment and testing.

Helpful, but optional:

- [Ganache](https://github.com/trufflesuite/ganache#getting-started) for local blockchain development.
- [Infura](https://infura.io/) account and Project ID.
- [MetaMask](https://metamask.io/) account.

### **Why Ganache, Infura, and MetaMask?**

[Ganache](https://github.com/trufflesuite/ganache#getting-started) is a personal blockchain for Ethereum development, providing a local blockchain environment. [Infura](https://infura.io/) offers a scalable and reliable Ethereum and IPFS infrastructure. [MetaMask](https://metamask.io/) is a popular Ethereum wallet and browser extension.

## **Installation**

#### **Clone with HTTPS:**

```bash
# Clone the repository with HTTPS.
git clone https://github.com/kevalsayar/SmartContracts.git
```

#### **Clone with SSH:**

```bash
# Clone the repository with SSH.
git clone git@github.com:kevalsayar/SmartContracts.git
```

### Navigate to the project directory

```bash
cd SmartContracts/fractionalNFTs
```

### Install dependencies

```bash
$ npm install
```

## **Configuration**

### Environment Variables:

Create a new file named .env in the root of the project. Copy the variable names from the example.env file and populate their values in the .env file.

## **Usage**

### **Deploying Contracts**

- #### **Compile Contracts**
  ```
  $ truffle compile --all
  ```
- #### **Migrate Contracts**

  Deploy the fractionalNFTs smart contract to the Binance Smart Chain:

  ```bash
  $ truffle migrate --network <Network Name>
  ```

- #### **Verify & Publish Contracts**

  ```
  $ truffle run verify <Contract Name> --network <Network Name>
  ```

## **Testing**

Run tests to ensure the fractionalNFTs contract behaves as expected:

```
$ truffle test
```

The test suite includes comprehensive tests to validate the functionality and behavior of the fractionalNFTs smart contract. Ensure all tests pass before deploying the contract in a production environment.

## **Examples**

Please see the [Official Truffle Documentation](https://trufflesuite.com/docs/) for guides, tips, and examples
