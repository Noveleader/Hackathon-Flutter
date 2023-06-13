require("hardhat-deploy");
const networkConfig = {
  31337: {
    name: "hardhat",
  },
  137: {
    name: "polygon",
  },
  80001: {
    name: "mumbai",
  },
};

const developmentChains = ["hardhat", "localhost"];
module.exports = {
  networkConfig,
  developmentChains,
};
