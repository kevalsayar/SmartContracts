//Deploy FractionalNFT Smart Contract
require("dotenv").config();
const { deployProxy } = require("@openzeppelin/truffle-upgrades");
const FractionalNFT = artifacts.require("FractionalNFT");
const { NFTname, NFTsymbol } = process.env;

module.exports = async function (deployer) {
  await deployProxy(FractionalNFT, [NFTname, NFTsymbol], {
    deployer,
    initializer: "initialize",
  });
};
