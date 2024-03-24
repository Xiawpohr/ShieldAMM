// @ts-ignore -- no types
import { BarretenbergWasm } from '@noir-lang/barretenberg';
// @ts-ignore -- no types
import { SinglePedersen, Schnorr } from '@noir-lang/barretenberg';

const CUT_LENGTH = 31

export function parseHexNote(hexNote: string) {
  const buffNote = Buffer.from(hexNote.slice(2), 'hex')

  const commitment = buffPedersenHash(buffNote)

  const nullifierBuff = buffNote.slice(0, CUT_LENGTH)
  const nullifierHash = BigInt(buffPedersenHash(nullifierBuff))
  const nullifier = BigInt(bufferToBigInt(buffNote.slice(0, CUT_LENGTH)))

  const secret = BigInt(bufferToBigInt(buffNote.slice(CUT_LENGTH, CUT_LENGTH * 2)))

  return {
    secret,
    nullifier,
    commitment,
    nullifierBuff,
    nullifierHash,
    commitmentHex: toFixedHex(commitment),
    nullifierHex: toFixedHex(nullifierHash)
  }
}

export async function pedersenHash() {
  const barretenberg = await BarretenbergWasm.new();
  await barretenberg.init()
  const pedersen = new SinglePedersen(barretenberg);
  pedersen.compressInputs([sender_pubkey_x, sender_pubkey_y, secret]);
}

export function bufferToBigInt(buffer: Buffer) {
  const bufferAsHexString = buffer.toString("hex");
  return BigInt(`0x${bufferAsHexString}`);
}

export function toFixedHex(value: Buffer | number, length = 32) {
  const isBuffer = value instanceof Buffer

  const str = isBuffer ? value.toString('hex') : BigInt(value).toString(16)
  return '0x' + str.padStart(length * 2, '0')
}