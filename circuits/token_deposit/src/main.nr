use dep::std;

#[recursive]
fn main(
    token: pub Field,
    amount: pub Field, // denominator is 10000
    nullifierHash: pub Field,
    note_root: pub Field, 
    index: Field,
    note_hash_path: [Field; 20],
    signature: Field,
    secret: Field,
) {
    let note_commitment = std::hash::pedersen_hash([token, amount, signature, secret]);

    let nullifier = std::hash::pedersen_hash([note_commitment, index, signature]);
    assert(nullifierHash == nullifier);

    let new_root = std::merkle::compute_merkle_root(note_commitment, index, note_hash_path);
    assert(new_root == note_root);
}

// #[test]
// fn test_main() {
//     // main(1, 2);
//     // Uncomment to make test fail
//     // main(1, 1);
// }
