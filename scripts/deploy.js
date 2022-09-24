// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {

  let gateway_ = "0x6f015F16De9fC8791b234eF68D486d2bF203FBA8";
  let gasreceiver_ = "0x2d5d7d31F671F86C782533cc367F14109a082712";
  const Contract = await hre.ethers.getContractFactory("PolygonSender");
  const contract = await Contract.deploy(gateway_, gasreceiver_ );

  await contract.deployed();

  console.log(
    `Deployed with gateway address ${gateway_} deployed to ${contract.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
