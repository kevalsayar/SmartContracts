// Deploy FractionalNFT & FNFToken Smart Contract
require("dotenv").config();
const { deployProxy } = require("@openzeppelin/truffle-upgrades");
const FractionalNFT = artifacts.require("FractionalNFT");
const FNFToken = artifacts.require("FNFToken");
const ERC20Beacon = artifacts.require("ERC20Beacon");
const { NFTname, NFTsymbol } = process.env;

module.exports = async function (deployer) {
  await deployer.deploy(ERC20Beacon);
  await deployer.deploy(FNFToken);
  const instance = await FNFToken.deployed();
  await deployProxy(FractionalNFT, [NFTname, NFTsymbol, instance.address], {
    deployer,
    initializer: "initialize",
  });
};
