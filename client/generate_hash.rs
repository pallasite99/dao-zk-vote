// Run with: cargo run --bin generate_hash

use sha2::{Digest, Sha256};

fn main() {
    let secret = b"my-secret-code";
    let hash = Sha256::digest(secret);
    println!("Secret: {:?}", std::str::from_utf8(secret).unwrap());
    println!("Hash (hex): 0x{}", hex::encode(hash));
}
