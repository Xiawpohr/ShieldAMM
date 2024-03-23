use dep::std;

fn main(
    base_token: pub Field,
    quote_token: pub Field,
    commitment_after_swap: pub Field,
    expected_amount_out: Field,
    priv_key : Field,
    secret: Field,
    deposit_verification_key : [Field; 114], 
    deposit_proof : [Field; 93], 
    deposit_public_inputs : [Field; 4],
    deposit_key_hash : Field,
    calculation_verification_key : [Field; 114], 
    calculation_proof : [Field; 93], 
    calculation_public_inputs : [Field; 6],
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

    let from_token = deposit_public_inputs[0];
    let deposit_amount = deposit_public_inputs[1];

    let amount_in = calculation_public_inputs[4];
    let amount_out = calculation_public_inputs[5];

    assert(deposit_amount == amount_in);
    assert(expected_amount_out == amount_out);

    // verify note commitment after swapping tokens
    let pubkey = std::scalar_mul::fixed_base_embedded_curve(priv_key, 0);
    let pubkey_x = pubkey[0];
    let pubkey_y = pubkey[1];

    let mut to_token = quote_token;
    if (from_token == quote_token) {
        to_token = base_token;
    }

    let note_commitment = std::hash::pedersen_hash([pubkey_x, pubkey_y, to_token, expected_amount_out, secret]);

    assert(commitment_after_swap == note_commitment);
}

// #[test]
// fn test_main() {
//     main(1, 2);
//     // Uncomment to make test fail
//     // main(1, 1);
// }
