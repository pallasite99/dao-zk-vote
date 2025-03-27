#![cfg_attr(not(feature = "std"), no_std)]

#[ink::contract]
mod dao_zk_vote {
    use ink::env::hash::{Sha2x256, HashOutput};

    #[ink(storage)]
    pub struct DaoZkVote {
        vote_hash: Hash,   // Commitment to a voter's secret
        yes_votes: u32,
        no_votes: u32,
    }

    impl DaoZkVote {
        #[ink(constructor)]
        pub fn new(secret_hash: Hash) -> Self {
            Self {
                vote_hash: secret_hash,
                yes_votes: 0,
                no_votes: 0,
            }
        }

        #[ink(message)]
        pub fn vote(&mut self, choice: bool, secret: Vec<u8>) -> bool {
            let mut hash_output = <Sha2x256 as HashOutput>::Type::default();
            ink::env::hash_bytes::<Sha2x256>(&secret, &mut hash_output);
            let calculated_hash = Hash::from(hash_output);

            if calculated_hash != self.vote_hash {
                return false; // Invalid proof
            }

            if choice {
                self.yes_votes += 1;
            } else {
                self.no_votes += 1;
            }

            // Prevent reuse
            self.vote_hash = Hash::default();

            true
        }

        #[ink(message)]
        pub fn get_results(&self) -> (u32, u32) {
            (self.yes_votes, self.no_votes)
        }
    }
}
