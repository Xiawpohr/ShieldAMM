import { readFileSync } from 'fs';
import path from 'path';
import { ethers } from "hardhat";
import { ContractFactory } from "ethers";
import type { HardhatEthersSigner } from '@nomicfoundation/hardhat-ethers/signers';


async function main() {
  const signers = await ethers.getSigners();
  const hasherContract = await deployHasher(signers);
  const hasherAddress = await hasherContract.getAddress();
  console.log("Hasher address:", hasherAddress);
}

async function deployHasher(signers: HardhatEthersSigner[]) {
  let hasherArtifactData = readFileSync(path.resolve(__dirname, '../build/Hasher.json'));
  const hasherArtifactString = Buffer.from(hasherArtifactData).toString('utf8')
  
  const hasherParsedArtifact = JSON.parse(hasherArtifactString)
  
  const Hasher = new ContractFactory(hasherParsedArtifact.abi, hasherParsedArtifact.bytecode, signers[0]);
  const hasherContract = await Hasher.deploy();

  return hasherContract;
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
