require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

const PRIVATE_KEY_POLYGON = process.env.PRIVATE_KEY_POLYGON;
const POLYGON_RPC_URL = process.env.POLYGON_RPC_URL;
const POLYGON_API_KEY = process.env.POLYGON_API_KEY;


/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.15",
  defaultNetwork: "hardhat",
  networks: {
    polygon: {
      url: POLYGON_RPC_URL,
      accounts:[PRIVATE_KEY_POLYGON],
      saveDeployments: true,
      chainId: 80001,
    }
  },
};
