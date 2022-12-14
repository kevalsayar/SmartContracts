// Deploy FractionalNFT & FNFToken Smart Contract
require("dotenv").config();
const { deployProxy } = require("@openzeppelin/truffle-upgrades");
const FractionalNFT = artifacts.require("FractionalNFT");
const FNFToken = artifacts.require("FNFToken");
const { NFTname, NFTsymbol } = process.env;

module.exports = async function (deployer) {
  await deployer.deploy(FNFToken);
  await deployProxy(FractionalNFT, [NFTname, NFTsymbol], {
    deployer,
    initializer: "initialize",
  });
};
