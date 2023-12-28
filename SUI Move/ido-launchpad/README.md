# **IDO Launchpad Smart Contract**

## **Overview**

The IDO Launchpad Smart Contract serves as a robust and decentralized platform designed to facilitate Initial DEX Offerings (IDOs) within the blockchain ecosystem. Built on the principles of transparency, security, and efficiency, this smart contract empowers blockchain projects to seamlessly launch and distribute their tokens while ensuring a fair and accessible fundraising process.

## Key Features:

- **Decentralized Fundraising:** The smart contract enables projects to conduct decentralized fundraising events, allowing contributors to participate directly from their wallets.

- **Token Sale Automation:** Automation of the token sale process ensures a streamlined experience for both project teams and contributors, reducing manual intervention and enhancing efficiency.

- **Fair Distribution Mechanism:** Incorporates mechanisms for fair token distribution, preventing whales and ensuring that all participants have an equal opportunity to acquire project tokens.

- **Smart Contract Audited Security:** Prioritizing security, the smart contract undergoes thorough audits to identify and mitigate vulnerabilities, providing a secure environment for token sales.
- **Customizable Parameters:** Project teams have the flexibility to customize parameters such as token price, allocation limits, and sale duration, tailoring the IDO to their specific requirements.

- **Community Governance:** Implementation of decentralized governance features empowers the community to participate in decision-making processes related to the IDO Launchpad's operation and future developments.

- **Interoperability:** Designed to be compatible with major blockchain networks, the smart contract supports interoperability, allowing projects to launch IDOs on various blockchain ecosystems.

## Smart Contract Details

- **Contract Name:** ido_contract.move
- **Network:** SUI Testnet
- **Version:** 1.0.0

## Table of Contents

1. [Getting Started](#getting-started)
   - [Installation](#installation)
2. [Usage](#usage)
   - [Deploying Contracts](#deploying-contracts)

## **Getting Started**

To deploy and interact with the IDO Launchpad smart contract, follow the steps below:

## **Installation**

1.  **Let’s assume you have Rust installed, if not install it via the following command in your terminal**

    ```bash
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    ```

2.  **Install the Sui CLI**

    ```bash
    cargo install --locked --git https://github.com/MystenLabs/sui.git --branch devnet sui sui-node
    ```

    **If you’re having issues you may need to install dependencies, I’ll point you to the [Sui docs](https://docs.sui.io/build/install).**

3.  **Sui CLI 💻**

        Let’s first configure the Sui Client:

        ```bash
        sui client
        ```

        This command should prompt you with two questions, type `y` and then `[enter]`. The result should generate a Sui Config file at `~/.sui/sui_config` and point the dev net to `https://fullnode.devnet.sui.io:443`.

    Next, let’s generate a new wallet address and fund that wallet with some Sui tokens.

    - **Generate a new address:**

      ```bash
      sui client new-address ed25519
      ```

      This will output the address and a mnemonic phrase which you should backup and keep safe. This is essentially your private key.

      You can check your active address via `sui client active-address` and switch to a new address via `sui client switch --address [ADDRESS]`

    - **Obtain some Sui tokens to pay for gas. Note Sui tokens are stored in Gas Objects. We’ll get into what Objects are later.**

      The following command will hit the Sui dev net faucet and transfer some tokens over:

      ```bash
        curl --location --request POST 'https://faucet.devnet.sui.io/gas' \
        --header 'Content-Type: application/json' \
        --data-raw '{"FixedAmountRequest":{"recipient":"0x7d76f97e7ef402d769c14d37d50bd0ff5387054e"}}
      ```

      **Note: You’ll need to replace `recipient` with the address you generated above.**

      You can check your balance via `sui client gas` which will output something like this:

      ```bash
      Object ID | Gas Value
      — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — —
      0x87005db87b63122393bef1d096625005a958d4f6 | 49998362
      ```

## **Usage**

### **Deploying Contracts**

Publish the contract to the Sui dev net.

```bash
sui client publish --gas-budget 1000
```

_**Note: make sure you’re in the ido_contract directory**_
