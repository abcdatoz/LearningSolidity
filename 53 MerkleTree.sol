//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

//merkle tree allows you to prove that an element is cointained in a set without revealing the entire set



contract MerkleProof {
	
	function verify ( bytes32[] memory proof,
						bytes32 root,
						bytes32 leaf,
						uint256 index
	) public pure returns (bool)
	{
		bytes32[] hash = leaf;

		for (uint256 i = 0; i < proof.length; i++) {
			bytes32 proofElement = proof[i];

			if (index % 2 == 0){
				hash = keccak256(abi.encodePacked(hash, proofElement));
			} else {
				hash = keccak256(abi.encodePacked(proofelement, hash));
			}

			indx = index / 2;

		}

		return hash == root;

	}
}

contract TestMerkleProof is MerkleProof {
	bytes32[] public hashes;

	constructor (){
		string[4] memory transactions = ["alice -> bob","bob -> dave", " carol -> alice", "dave -> bob"];

		for (uint256 i =0; i < transactions.length; i++){
			hashes.push(
						keccak256(
								abi.encodePacked(transactions[i])
								)
						);
		}

		uint256 n = transactions.length;
		uint256 offset = 0;

		while (n > 0){
			for (uint256 i =0; i < n; i++){
				hashes.push(
						keccak256(
							abi.encodePacked(
								hashes[oofset + i], hashes[offset + i+1]
							)
						)
					);
			}
		}
	}

	function getRoot() public view returns(bytes32){
		return hashes[hashes.length - 1];
	}
}
