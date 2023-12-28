# Escrow Smart Contract

## Overview

This directory contains the source code and documentation for the Escrow smart contract as part of the Escrow2.0 project. The Escrow contract facilitates secure and transparent transactions between buyers and sellers by holding funds in escrow until predetermined conditions are met.

## Escrow Contract Features

- **Supported Networks:** Binance Smart Chain (BSC)
- **Smart Contract Type:** Escrow
- **Multisignature Wallet:** Enabled
- **Conditional Release:** Customizable

## Smart Contract Details

- **Contract Name:** Escrow.sol
- **Network:** Binance Smart Chain (BSC)
- **Version:** 1.0.0

## Table of Contents

1. [Getting Started](#getting-started)
   - [Prerequisites](#prerequisites)
   - [Installation](#installation)
2. [Usage](#usage)
   - [Deploying Contracts](#deploying-contracts)
   - [Interacting with Contracts](#interacting-with-contracts)
3. [Testing](#testing)
4. [Examples](#examples)

## **1. Getting Started**

To deploy and interact with the BEP-20 token smart contract, follow the steps below:

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
cd SmartContracts/escrow
```

### Install dependencies

```bash
$ npm install
```

## **Configuration**

### Environment Variables:

Create a new file named .env in the root of the project. Copy the variable names from the example.env file and populate their values in the .env file.

## **2. Usage**

### **Deploying Contracts**

- #### **Compile Contracts**
  ```
  $ truffle compile --all
  ```
- #### **Migrate Contracts**

  Deploy the escrow smart contract to the Binance Smart Chain:

  ```bash
  $ truffle migrate --network <Network Name>
  ```

- #### **Verify & Publish Contracts**

  ```
  $ truffle run verify <Contract Name> --network <Network Name>
  ```

## **3. Testing**

Run tests to ensure the escrow contract behaves as expected:

```
$ truffle test
```

The test suite includes comprehensive tests to validate the functionality and behavior of the escrow smart contract. Ensure all tests pass before deploying the contract in a production environment.

## **4. Examples**

Please see the [Official Truffle Documentation](https://trufflesuite.com/docs/) for guides, tips, and examples
