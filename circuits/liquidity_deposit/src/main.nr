use dep::std;

fn main(
    amount: pub Field, // denominator is 10000
    nullifierHash: pub Field,
    note_root : pub Field, 
    index : Field,
    note_hash_path : [Field; 20],
    priv_key : Field,
    secret: Field,
) {
    let pubkey = std::scalar_mul::fixed_base_embedded_curve(priv_key, 0);
    let pubkey_x = pubkey[0];
    let pubkey_y = pubkey[1];

    let note_commitment = std::hash::pedersen_hash([pubkey_x, pubkey_y, amount, secret]);

    let nullifier = std::hash::pedersen_hash([note_commitment, index, priv_key]);
    assert(nullifierHash == nullifier);

    let new_root = std::merkle::compute_merkle_root(note_commitment, index, note_hash_path);
    assert(new_root == note_root);
}

// #[test]
// fn test_main() {
//     main(1, 2);
//     // Uncomment to make test fail
//     // main(1, 1);
// }
