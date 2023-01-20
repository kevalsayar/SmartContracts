require("dotenv").config();
var SampleToken = artifacts.require("SampleToken");
const { name, symbol, supply } = process.env;

module.exports = async function (deployer) {
  await deployer.deploy(SampleToken, name, symbol, supply);
};
