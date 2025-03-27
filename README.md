# ZKDAO
ZKDAO: Anonymous Voting in DAOs using Zero-Knowledge Proofs on Polkadot

## Project Description

* This project explores privacy-preserving voting for DAOs (Decentralized Autonomous Organizations) on the Polkadot blockchain. It enables eligible members to vote anonymously while proving their eligibility using zero-knowledge proofs (ZKPs) — without revealing their identity or wallet address.
* The smart contract is written in ink! and targets the Polkadot Virtual Machine (PVM). The proof of concept uses zkSNARKs (via ZoKrates or Risc0) to verify a voter's membership (e.g., inclusion in a Merkle Tree of eligible voters). Valid votes are cast anonymously and securely tallied on-chain.
* This project aligns with Polkadot’s vision of scalable, interoperable, and privacy-respecting Web3 governance.

## ZK Proof Concept
![image](https://github.com/user-attachments/assets/023fd870-999f-4a48-a76a-9c95edce20a0)

## Research and Analysis

| Topic                         | Summary                                                                 |
|------------------------------|-------------------------------------------------------------------------|
| **ink! Smart Contracts**      | Explored ink! for writing Rust-based contracts on PVM. Focused on building voting mechanisms and managing on-chain state. |
| **Zero-Knowledge Proofs (zkSNARKs)** | Studied ZoKrates and Risc0 as ZKP systems. Implemented simple Merkle tree inclusion proofs. |
| **Anonymous Voting Mechanisms** | Investigated Semaphore protocol and other ZK-based voting schemes to understand privacy layers. |
| **PVM Compatibility**         | Verified that ink! contracts can accept off-chain ZK proof data as input. Researched potential for future on-chain verification integration. |
| **DAO Governance Patterns**   | Analyzed existing DAO voting structures to align with realistic governance flows. |

## Demo (Expected flow)

### Goal

Show anonymous voting where a voter proves eligibility via a **hash of a shared secret**, without revealing identity — and vote is only accepted once.

---

## Prerequisites

- `cargo-contract` installed
- Contract built via: `cargo contract build`
- Access to [Contracts UI](https://contracts-ui.substrate.io)
- Rust installed for CLI hash generator

---

## Test Simulation

### 1. Generate the ZK Hash (Simulated)

```bash
cd client
cargo run --bin generate_hash
```

### Sample Output

```bash
Secret: "my-secret-code"
Hash (hex): 0x6f9249aef23606f3d8fc214624cb4bcce7a37c0ea190cb5ff1a3e1eb6e55800b
```

---

### 2. Deploy Smart Contract with Hash

Go to: [https://contracts-ui.substrate.io](https://contracts-ui.substrate.io)

- Click **Upload contract**
- Upload the `.contract` file from `contracts/dao_zk_vote/target/ink`
- Constructor: pass the hash from above:
  
```bash
0x6f9249aef23606f3d8fc214624cb4bcce7a37c0ea190cb5ff1a3e1eb6e55800b
```

- Click **Deploy**

---

### 3. Cast a Valid Vote

Call the `vote` method:

- `choice`: `true` (for "yes")
- `secret`: `"my-secret-code"` as UTF-8 bytes

In UI:
- Choose `Vec<u8>` input
- Type: `["109", "121", "-", "115", "101", "99", "114", "101", "116", "-", "99", "111", "100", "101"]`

> Tip: You can convert strings to UTF-8 byte arrays [here](https://onlineutf8tools.com/convert-text-to-utf8)

Result: `true`  
Explanation: Proof was valid, vote accepted

---

### 4. Check Vote Result

Call: `get_results()`

Output:
```bash
(1, 0)
```

---

### ❌ 5. Try Reusing the Same Secret

Call `vote` again with the same secret:

❌ Output: `false`  
📟 Explanation: Contract zeroes the hash after one use to prevent re-voting

---

### ❌ 6. Try Voting with Wrong Secret

Use `"wrong-secret"` → its hash won't match

❌ Output: `false`  
📟 Explanation: Invalid proof (hash mismatch)

---

### Summary

| Action                         | Input                 | Expected Result | Status |
|-------------------------------|------------------------|-----------------|--------|
| Deploy contract               | `hash(secret)`         | Contract deployed | ✅     |
| Vote with correct secret      | `"my-secret-code"`     | Vote accepted    | ✅     |
| View results                  | -                      | `(1, 0)`         | ✅     |
| Vote again with same secret   | `"my-secret-code"`     | Rejected         | ✅     |
| Vote with wrong secret        | `"wrong-secret"`       | Rejected         | ✅     |

---

### Bonus: Add More Voters

You can deploy with a different `hash(secret)` for each eligible voter or use a list/Merkle tree approach (next phase).



## Conclusions
1. `Feasibility`: Anonymous voting in DAOs using ZKPs is achievable with Polkadot's ink! and off-chain proof generation tools.
2. `Best Fit ZK Tool`: ZoKrates is developer-friendly and integrates well with off-chain/on-chain communication flow.
3. `Privacy-Utility Tradeoff`: Off-chain proof generation ensures privacy but adds complexity to UX; future enhancements could explore on-chain verification or MPC.
4. `Business Case`: Anonymous, verifiable governance is essential for DAOs where vote coercion or privacy concerns exist — this adds real-world value to DAO operations.
5. `Scalability Potential`: Can be extended to quadratic voting, weighted voting, or privacy-preserving referendums.

