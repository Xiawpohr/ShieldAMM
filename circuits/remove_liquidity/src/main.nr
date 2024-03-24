use dep::std;

fn main(
    commitment_after_remove_liquidity: pub Field,
    token: Field,
    token_amount: Field,
    signature: Field,
    secret: Field,
    deposit_verification_key : [Field; 114], 
    deposit_proof : [Field; 93], 
    deposit_public_inputs : [Field; 3],
    deposit_key_hash : Field,
    calculation_verification_key : [Field; 114], 
    calculation_proof : [Field; 93], 
    calculation_public_inputs : [Field; 5],
    calculation_key_hash : Field,
) {
    // verify deposit proof
    std::verify_proof(
        deposit_verification_key.as_slice(), 
        deposit_proof.as_slice(), 
        deposit_public_inputs.as_slice(), 
        deposit_key_hash,
    );

    // verify swap calculations
    std::verify_proof(
        calculation_verification_key.as_slice(), 
        calculation_proof.as_slice(), 
        calculation_public_inputs.as_slice(), 
        calculation_key_hash,
    );

    let deposit_amount = deposit_public_inputs[0];

    let amount_in = calculation_public_inputs[3];
    let amount_out = calculation_public_inputs[4];

    assert(deposit_amount == amount_in);
    assert(token_amount == amount_out);

    // verify note commitment after remove liquidity
    let note_commitment = std::hash::pedersen_hash([token, token_amount, signature, secret]);

    assert(commitment_after_remove_liquidity == note_commitment);
}

// #[test]
// fn test_main() {
//     main(1, 2);
//     // Uncomment to make test fail
//     // main(1, 1);
// }
