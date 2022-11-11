//Deploy Escrow and EscrowFactory Smart Contract
const Escrow = artifacts.require("Escrow");
const EscrowFactoryContract = artifacts.require("EscrowFactory");

const { deployProxy } = require("@openzeppelin/truffle-upgrades");

module.exports = async function (deployer) {
  // deployer.deploy(Escrow).then(function() {
  //   return deployer.deploy(EscrowFactoryContract, Escrow.address);
  // });
  deployer.deploy(Escrow).then(async function(){
    await deployProxy(EscrowFactoryContract, [Escrow.address], {
      deployer,
      initializer: "initialize",
    });
  });
  // deployer.deploy(EscrowFactoryContract);
  // await deployBeacon(
  //   Escrow,
  //   // [
  //   //   "0x0BED72D78b98e2D06E6C43Ecf374341E74c8d697",
  //   //   10000000000,
  //   //   2,
  //   //   "0x3721430091076C0be6e96CE17E7DC22A2e173b57"
  //   // ],
  //   { deployer, initializer: false }
  // );
  
};
