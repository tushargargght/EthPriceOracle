const EthPriceOracle = artifacts.require("EthPriceOracle");

module.exports = function (deployer, network, accounts) {
    deployer.deploy(EthPriceOracle, accounts[0]);
};
