require("dotenv").config();
const BlindAuction = artifacts.require("BlindAuction");
const { biddingTime, revealTime, beneficiary } = process.env;

module.exports = async function (deployer) {
  await deployer.deploy(BlindAuction, biddingTime, revealTime, beneficiary);
};
