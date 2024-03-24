import { ethers } from "hardhat";

const hasherAddress = '0x5c6A2101890195716Ee63aDE4De14A779AE50e0a'

// optimism
// const BaseToken = {
//   target: "0x304Ed679c69275a8B12A6663983eBc4619DA7C3a"
// }
// const QuoteToken = {
//   target: "0xD28BDAD0ED2Cc5B15C6076180457b052886F6Ce9"
// }
// const AddLiquidityVerifier = {
//   target: "0x74b88b2102852cc333B709485bbF2C49ab36817A"
// }
// const RemoveLiquidityVerifier = {
//   target: "0x48a5BEE3c4F8b48B3bCacbDB0DB13468Dcb26fA1"
// }
// const SwapVerifier = {
//   target: "0xEdbE93b0C9209ee404883748a6e30BCDFa8e397b"
// }
// const TokenDepositVerifier = {
//   target: "0xC8A9D09B83364Bac3057d7771042F2e65DE7fD66"
// }

async function main() {
  const [deployer] = await ethers.getSigners();

  const TokenFactory = await ethers.getContractFactory("MockToken");

  const BaseToken = await TokenFactory.deploy("Base token", "BASE", 4);
  console.log("base token:", BaseToken.target);

  const QuoteToken = await TokenFactory.deploy("Quote token", "QUOTE", 4);
  console.log("quote token:", QuoteToken.target);

  const AddLiquidityVerifierFactory = await ethers.getContractFactory("AddLiquidityUltraVerifier");
  const AddLiquidityVerifier = await AddLiquidityVerifierFactory.deploy();
  console.log("add liquidity verifier:", AddLiquidityVerifier.target);

  const RemoveLiquidityVerifierFactory = await ethers.getContractFactory("RemoveLiquidityUltraVerifier");
  const RemoveLiquidityVerifier = await RemoveLiquidityVerifierFactory.deploy();
  console.log("remove liquidity verifier:", RemoveLiquidityVerifier.target);


  const SwapVerifierFactory = await ethers.getContractFactory("SwapUltraVerifier");
  const SwapVerifier = await SwapVerifierFactory.deploy();
  console.log("swap verifier:", SwapVerifier.target);

  const TokenDepostiVerifierFactory = await ethers.getContractFactory("TokenDepositUltraVerifier");
  const TokenDepositVerifier = await TokenDepostiVerifierFactory.deploy();
  console.log("token deposit verifier:", TokenDepositVerifier.target);

  const MerkleTreeWithHistoryLibFactory = await ethers.getContractFactory("MerkleTreeWithHistoryLib");
  const MerkleTreeWithHistoryLib = await MerkleTreeWithHistoryLibFactory.deploy();

  const ShieldAMMFactory = await ethers.getContractFactory("ShieldAMM", {
    libraries: {
      MerkleTreeWithHistoryLib: MerkleTreeWithHistoryLib.target,
    },
  });
  const shieldAMM = await ShieldAMMFactory.deploy(
    BaseToken.target,
    QuoteToken.target,
    TokenDepositVerifier.target,
    SwapVerifier.target,
    AddLiquidityVerifier.target,
    RemoveLiquidityVerifier.target,
    hasherAddress
  )
  console.log("shield AMM address:", shieldAMM.target);

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
        console.error(error);
        process.exit(1);
  });