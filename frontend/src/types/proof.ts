export interface ProofArtifacts {
  proof: Uint8Array;
  publicInputs: string[];
  proofAsFields: string[];
  vkAsFields: string[];
  vkHash: string;
}