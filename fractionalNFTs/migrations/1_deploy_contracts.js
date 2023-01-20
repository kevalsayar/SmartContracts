// Deploy FractionalNFT & FNFToken Smart Contract

require("dotenv").config();
const { deployProxy, upgradeProxy } = require("@openzeppelin/truffle-upgrades");
const FractionalNFT = artifacts.require("FractionalNFT");
// const FractionalNFTV1 = artifacts.require("FractionalNFTV1");
const FNFToken = artifacts.require("FNFToken");
const { NFTname, NFTsymbol } = process.env;

module.exports = async function (deployer) {
  // Comment lines 12-16 whilst upgrading proxy contracts.
  await deployer.deploy(FNFToken);
  await deployProxy(FractionalNFT, [NFTname, NFTsymbol], {
    deployer,
    initializer: "initialize",
  });

  // Uncomment lines 19-12 whilst upgrading proxy contracts.
  // const instance = await FractionalNFT.deployed();
  // const upgrade = await upgradeProxy(instance.address, FractionalNFTV1, {
  //   deployer,
  // });
};
