const { deployProxy } = require("@openzeppelin/truffle-upgrades"),
  Escrow = artifacts.require("Escrow"),
  EscrowFactoryContract = artifacts.require("EscrowFactory");

module.exports = async function (deployer) {
  deployer.deploy(Escrow).then(async function () {
    await deployProxy(EscrowFactoryContract, [Escrow.address], {
      deployer,
      initializer: "initialize",
    });
  });
};
