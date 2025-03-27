// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/// @title ZKDAO Vote Simulated (with proper constructor detection for Remix)
contract ZKDaoVoteSimulated {
    bytes32 public committedHash;
    uint public yesVotes = 0;
    uint public noVotes = 0;
    bool public voted = false;

    string private storedSecret;

    /// Constructor receives dummy input to trigger Remix UI correctly
    constructor(string memory _dummyInit) {
        storedSecret = "demo-vote-secret";
        committedHash = keccak256(abi.encodePacked(storedSecret));
    }

    function vote(bool choice, string memory secret) public returns (bool) {
        require(!voted, "Already voted");

        if (keccak256(abi.encodePacked(secret)) != committedHash) {
            return false;
        }

        if (choice) {
            yesVotes += 1;
        } else {
            noVotes += 1;
        }

        voted = true;
        return true;
    }

    function getResults() public view returns (uint, uint) {
        return (yesVotes, noVotes);
    }

    function getCommitment() public view returns (bytes32) {
        return committedHash;
    }
}
