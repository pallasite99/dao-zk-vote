// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/// @title ZKDAO Vote (Simulated Commitment Version)
/// @notice This contract internally sets a secret and computes its hash for anonymous vote simulation.
contract ZKDaoVoteSimulated {
    bytes32 public committedHash;
    uint public yesVotes = 0;
    uint public noVotes = 0;
    bool public voted = false;

    string private constant SECRET = "demo-vote-secret"; // Simulated secret

    constructor() {
        // Compute the hash internally so no input needed
        committedHash = keccak256(abi.encodePacked(SECRET));
    }

    /// @notice Cast a vote by revealing the secret
    /// @param choice true = yes, false = no
    /// @param secret The string that should match the hidden one
    function vote(bool choice, string memory secret) public returns (bool) {
        require(!voted, "Already voted");

        if (keccak256(abi.encodePacked(secret)) != committedHash) {
            return false; // Invalid proof
        }

        if (choice) {
            yesVotes += 1;
        } else {
            noVotes += 1;
        }

        voted = true;
        return true;
    }

    /// @notice Get current vote results
    function getResults() public view returns (uint, uint) {
        return (yesVotes, noVotes);
    }
}
