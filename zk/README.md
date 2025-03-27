# ZoKrates – ZK Membership Proof

This folder contains the ZoKrates circuit to prove that a user is part of a Merkle tree of valid DAO members (without revealing their identity).

## Requirements
- Docker
- ZoKrates (built inside Docker)

## 🛠️ Commands

### Compile Circuit
```bash
docker run -v $PWD:/home/zokrates zokrates zokrates compile -i proof.zok
```

### Setup
1. Trusted
```bash
docker run -v $PWD:/home/zokrates zokrates zokrates setup
```
2. Compute Witness
```bash
docker run -v $PWD:/home/zokrates zokrates zokrates compute-witness -a 1234567890 111111 222222 333333 999999
```
3. Generate Proof
```bash
docker run -v $PWD:/home/zokrates zokrates zokrates generate-proof
```
