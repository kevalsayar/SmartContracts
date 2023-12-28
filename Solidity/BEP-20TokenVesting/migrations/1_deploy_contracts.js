require("dotenv").config();
var TokenVesting = artifacts.require("TokenVesting");
const { BEP20TokenAddress } = process.env;
// var TokenVestingV1 = artifacts.require("TokenVestingV1");
const { deployProxy, upgradeProxy } = require("@openzeppelin/truffle-upgrades");

module.exports = async function (deployer) {
  // Comment lines 9-12 while upgrading TokenVesting contract.
  await deployProxy(TokenVesting, [BEP20TokenAddress], {
    deployer,
    initializer: "initialize",
  });

  // Uncomment lines 15-19 while upgrading TokenVesting contract.
  // const instance = await TokenVesting.deployed();
  // const upgrade = await upgradeProxy(instance.address, TokenVestingV1, {
  //   deployer,
  // });
};
