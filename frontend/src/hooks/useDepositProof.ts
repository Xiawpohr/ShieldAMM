"use client";

import { toast } from "react-toastify";
import { useEffect, useState } from "react";
import { getCircuit } from "@/lib/utils/getCircuit";
import { BarretenbergBackend } from "@noir-lang/backend_barretenberg";
import { Noir } from "@noir-lang/noir_js";
import { ProofArtifacts } from "../types/proof";

export function useDepositProof(inputs?: { x: string; y: string }) {
  const [depositProofArtifacts, setDepositProofArtifacts] = useState<ProofArtifacts>();

  useEffect(() => {
    const proofGeneration = async () => {
      if (!inputs) {
        return;
      }
  
      const circuit = await getCircuit("token_deposit");
      const backend = new BarretenbergBackend(circuit, { threads: navigator.hardwareConcurrency });
      const noir = new Noir(circuit, backend);
  
      const { witness } = await noir.execute(inputs);
  
      const { publicInputs, proof } = await toast.promise(backend.generateProof(witness), {
        pending: "Generating proof",
        success: "Proof generated",
        error: "Error generating proof",
      });
  
      toast.promise(backend.verifyProof({ proof, publicInputs }), {
        pending: "Verifying intermediate proof",
        success: "Intermediate proof verified",
        error: "Error verifying intermediate proof",
      });
  
      const depositProofArtifacts = await backend.generateRecursiveProofArtifacts(
        { publicInputs, proof },
        1, // 1 public input
      );
  
      setDepositProofArtifacts({ proof, publicInputs, ...depositProofArtifacts });
    };

    proofGeneration();
  }, [inputs]);

  return depositProofArtifacts;
}
