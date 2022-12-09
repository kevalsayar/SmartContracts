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
const { MNEMONIC, JSON_RPC, bscAPIkey, polygonscanAPIkey } = process.env;

const HDWalletProvider = require("@truffle/hdwallet-provider");

module.exports = {
  /**
   * Networks define how you connect to your ethereum client and let you set the
   * defaults web3 uses to send transactions.
   */
  networks: {
    // The `development` name is special - truffle uses it by default
    // if it's defined here and no other network is specified at the command line.
    development: {
      host: "127.0.0.1", // Localhost (default: none)
      port: 8545, // Standard Ethereum port (default: none)
      network_id: "*", // Any network (default: none)
    },
    // Useful for deploying to a public network.
    // It's important to wrap the provider as a function to ensure truffle uses a new provider every time.
    mumbai: {
      provider: () => new HDWalletProvider(MNEMONIC, JSON_RPC),
      network_id: 80001, // Mumbai's network id.
      gasPrice: 30000000000,
      confirmations: 1, // Number of confirmations to wait between deployments. (default: 0)
      // timeoutBlocks: 200, // Number of blocks before a deployment times out.  (minimum/default: 50)
      skipDryRun: true,
    },
    polygon: {
      provider: () => new HDWalletProvider(MNEMONIC, JSON_RPC),
      network_id: 137, // Polygon's network id.
      confirmations: 2, // Number of confirmations to wait between deployments. (default: 0)
      timeoutBlocks: 200, //Number of blocks before a deployment times out.  (minimum/default: 50)
      skipDryRun: true,
    },
    bsct: {
      provider: () => new HDWalletProvider(MNEMONIC, JSON_RPC),
      network_id: 97, // Binance Testnet's network id.
      confirmations: 2, // Number of confirmations to wait between deployments. (default: 0)
      timeoutBlocks: 200, // Number of blocks before a deployment times out.  (minimum/default: 50)
      skipDryRun: true,
    },
  },

  // Set default mocha options here, use special reporters, etc.
  mocha: {
    // timeout: 100000
  },

  // Compiler Configurations.
  compilers: {
    solc: {
      version: "0.8.7", // Fetch exact version from solc-bin.
      docker: false, // Use "0.5.1" you've installed locally with docker.
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
    // https://docs.bscscan.com/getting-started/viewing-api-usage-statistics
    testnet_bscscan: bscAPIkey,
    // https://polygonscan.com/login
    polygonscan: polygonscanAPIkey,
  },
};
