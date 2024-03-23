import path from 'path';
import { writeFileSync } from 'fs';
import { mkdirp } from 'mkdirp';
// @ts-ignore -- no types
import { mimc7Contract as mimcContract } from 'circomlibjs';

const folderPath = path.join(__dirname, '..', 'build');
const outputPath = path.join(__dirname, '..', 'build', 'Hasher.json')

async function main() {
  const contract = {
    contractName: 'Hasher',
    abi: mimcContract.abi,
    bytecode: mimcContract.createCode('mimc', 91),
  }

  await mkdirp(folderPath);
  writeFileSync(outputPath, JSON.stringify(contract));
}

main()
