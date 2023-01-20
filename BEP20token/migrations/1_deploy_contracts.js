require("dotenv").config();
var SampleToken = artifacts.require("SampleToken");
// var TokenVesting = artifacts.require("TokenVesting");
const { name, symbol, supply } = process.env;
// var TokenVestingV1 = artifacts.require("TokenVestingV1");
// const { deployProxy, upgradeProxy } = require("@openzeppelin/truffle-upgrades");

module.exports = async function (deployer) {
  await deployer.deploy(SampleToken, name, symbol, supply);
  // const BEP20TokenInstance = await BEP20Token.deployed();
  // await deployer.deploy(
  //   TokenVesting,
  //   "0x026Af2C078fdFc24e6F4678D50350903CE244F7E",
  //   1674131400,
  //   60,
  //   720,
  //   60
  // );

  // await deployProxy(TokenVesting, [BEP20TokenInstance.address], {
  //   deployer,
  //   initializer: "initialize",
  // });
  // const instance = await TokenVesting.deployed();
  // const upgrade = await upgradeProxy(instance.address, TokenVestingV1, {
  //   deployer,
  // });
};
