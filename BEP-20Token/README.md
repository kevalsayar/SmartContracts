# BEP-20 Token Smart Contract

## Overview

This directory contains the source code and documentation for the BEP-20 token smart contract. The BEP-20 token is designed to comply with the Binance Smart Chain (BSC) standard for fungible tokens and serves as a key component in our blockchain-based escrow system.

## Token Features

- **Name:** Your Token Name
- **Symbol:** TOKEN
- **Decimals:** 18
- **Total Supply:** X Tokens

## Smart Contract Details

- **Contract Name:** BEP20.sol
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
- [Ganache](https://github.com/trufflesuite/ganache#getting-started) for local blockchain development.

Helpful, but optional:
- [Infura](https://infura.io/) account and Project ID.
- [MetaMask](https://metamask.io/) account.

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
cd SmartContracts/BEP-20Token
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
   
   Deploy the BEP-20 token smart contract to the Binance Smart Chain:

   ```bash
   $ truffle migrate --network <Network Name>
   ```
- #### **Verify & Publish Contracts**

   ```
   $ truffle run verify <Contract Name> --network <Network Name>
   ```

## **3. Testing**

Run tests to ensure the BEP-20 token contract behaves as expected:

```
$ truffle test
```

The test suite includes comprehensive tests to validate the functionality and behavior of the BEP-20 token smart contract. Ensure all tests pass before deploying the contract in a production environment.

## **4. Examples**

Please see the [Official Truffle Documentation](https://trufflesuite.com/docs/) for guides, tips, and examples
