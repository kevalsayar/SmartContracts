/**
 *
 * You'll need a mnemonic - the twelve word phrase the wallet uses to generate
 * public/private key pairs. You can store your secrets in a .env file.
 * Create .env (which should be .gitignored) and declare your MNEMONIC inside.
 *
 * For example, your .env file will have the following structure:
 * MNEMONIC = <Your 12 phrase mnemonic>
 *
 * Deployment with Truffle Dashboard (Recommended for best security practice)
 * https://trufflesuite.com/docs/truffle/getting-started/using-the-truffle-dashboard/
 *
 */

require("dotenv").config();
const HDWalletProvider = require("@truffle/hdwallet-provider");
const { MNEMONIC, JSON_RPC, bscAPIkey, polygonscanAPIkey } = process.env;

module.exports = {
  /**
   * Networks define how you connect to your ethereum client and let you set the
   * defaults web3 uses to send transactions. You can ask a truffle command to use a specific
   * network from the command line, e.g
   *
   * $ truffle test --network <network-name>
   */

  networks: {
    /**
     * Useful for testing. The `development` name is special - truffle uses it by default
     * if it's defined here and no other network is specified at the command line.
     * You should run a client (like ganache, geth, or parity) in a separate terminal
     * tab if you use this network and you must also set the `host`, `port` and `network_id`
     * options below to some value.
     */
    development: {
      host: "127.0.0.1", // Localhost (default: none)
      port: 8545, // Standard Ethereum port (default: none)
      network_id: "*", // Any network (default: none)
    },
    bsct: {
      provider: () => new HDWalletProvider(MNEMONIC, JSON_RPC),
      network_id: 97,
      confirmations: 1,
      timeoutBlocks: 200,
      skipDryRun: true,
    },
    // goerli: {
    //   provider: () => new HDWalletProvider(MNEMONIC, `https://goerli.infura.io/v3/${PROJECT_ID}`),
    //   network_id: 5,       // Goerli's id
    //   confirmations: 2,    // # of confirmations to wait between deployments. (default: 0)
    //   timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
    //   skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
    // }
  },

  // Set default mocha options here, use special reporters, etc.
  mocha: {
    timeout: 100000,
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.8.16", // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      // settings: {          // See the solidity docs for advice about optimization and evmVersion
      //  optimizer: {
      //    enabled: false,
      //    runs: 200
      //  },
      //  evmVersion: "byzantium"
      // }
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

  // Truffle DB is currently disabled by default; to enable it, change enabled:
  // false to enabled: true. The default storage location can also be
  // overridden by specifying the adapter settings, as shown in the commented code below.
  //
  // NOTE: It is not possible to migrate your contracts to truffle DB and you should
  // make a backup of your artifacts to a safe location before enabling this feature.
  //
  // After you backed up your artifacts you can utilize db by running migrate as follows:
  // $ truffle migrate --reset --compile-all
  //
  // db: {
  //   enabled: false,
  //   host: "127.0.0.1",
  //   adapter: {
  //     name: "sqlite",
  //     settings: {
  //       directory: ".db"
  //     }
  //   }
  // }
};
