/**
 * Use this file to configure your truffle project. It's seeded with some
 * common settings for different networks and features like migrations,
 * compilation, and testing.
 *
 * You'll need a mnemonic - the twelve word phrase your wallet uses to generate
 * public/private key pairs. You can store your secrets in a .env file.
 * In your project root, run `npm install dotenv -D`.
 * Create an .env (which should be .gitignored) and declare your MNEMONIC
 * and JSON_RPC variables inside.
 *
 * For example, your .env file will have the following structure:
 *
 * MNEMONIC = <Your 12 phrase mnemonic>
 * JSON_RPC = <Your Network's JSON-RPC url>
 */

require("dotenv").config();
const { MNEMONIC, JSON_RPC, bscAPIkey } = process.env;

const HDWalletProvider = require("@truffle/hdwallet-provider");

module.exports = {
  /**
   * Networks define how you connect to your ethereum client and let you set the
   * defaults web3 uses to send transactions.
   */
  networks: {
    // It's important to wrap the provider as a function to ensure truffle uses a new provider every time.
    bsct: {
      provider: () => new HDWalletProvider(MNEMONIC, JSON_RPC),
      network_id: 97, // Mumbai's network id.
      confirmations: 1, // Number of confirmations to wait between deployments. (default: 0)
      timeoutBlocks: 200, // Number of blocks before a deployment times out.  (minimum/default: 50)
      skipDryRun: true,
    },
  },

  // Compiler Configurations.
  compilers: {
    solc: {
      version: "0.8.17",
      docker: false,
      settings: {
        optimizer: {
          enabled: true,
          runs: 200,
        },
        evmVersion: "byzantium",
      },
    },
  },
  // Plugins.
  plugins: ["truffle-plugin-verify"],
  // API keys obtained from respective network's explorers.
  api_keys: {
    testnet_bscscan: bscAPIkey,
  },
};
