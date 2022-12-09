# **SmartContracts**

You'll find all kinds of smart contracts down here! Pop off!

- [Requirements](#requirements)
- [Setup](#setup)
  - [Installation](#installation)
- [Usage](#usage)
- [Documentation](#documentation)

---

<img src="https://trufflesuite.com/img/truffle-logo-dark.svg" width="200">

[![npm](https://img.shields.io/npm/v/truffle.svg)](https://www.npmjs.com/package/truffle)

This repo contains of smart contracts brought to life using **Truffle**, which is a development environment, testing framework, and asset pipeline for Ethereum, aiming to make life as an Ethereum developer easier.

Note that these are made upgradeable with the help of **OpenZeppelin's Upgrades** library which mainly helps in deploying upgradeable contracts with automated security checks.

---

## **Requirements**

These contracts have the following requirements:

- [Node.js](https://nodejs.org/) v12 or higher
- [Truffle](https://trufflesuite.com/docs/truffle/getting-started/installation)
- [Ganache](https://github.com/trufflesuite/ganache#getting-started)

Helpful, but optional:

- An [Infura](https://infura.io/) account and Project ID
- A [MetaMask](https://metamask.io/) account

## **Setup**

---

### **Installation**

```bash
$ npm install
```

#### **Prepping up the .env**

Before you proceed any further, you'll need to set up an `.env file`. You'll need to take a peek at the `.env.example` file provided to be aware of whats got to be stored in the `.env` and we're then good to go.

### **Usage**

- **Compile Contracts**

```
$ truffle compile --all
```

- **Migrate Contracts**

```
$ truffle migrate --network <Network Name>
```

- **Verify & Publish Contracts**

```
$ truffle run verify <Contract Name> --network <Network Name>
```

For a default set of contracts and tests, run the following within an empty project directory:

```
$ truffle init
```

From there, you can run `truffle compile`, `truffle migrate` and `truffle test`, `truffle run verify` to compile your contracts, deploy those contracts to the network, run their associated unit tests and verify them.

Truffle comes bundled with a local development blockchain server that launches automatically when you invoke the commands above. If you'd like to [configure a more advanced development environment](https://trufflesuite.com/docs/truffle/reference/configuration) we recommend you install the blockchain server separately by running `npm install -g ganache` at the command line.

- [ganache](https://github.com/trufflesuite/ganache): a command-line version of Truffle's blockchain server.
- [ganache-ui](https://github.com/trufflesuite/ganache-ui): A GUI for the server that displays your transaction history and chain state.

### **Documentation**

Please see the [Official Truffle Documentation](https://trufflesuite.com/docs/) for guides, tips, and examples.
