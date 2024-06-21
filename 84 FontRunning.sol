//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract FindThisHash {
	bytes32 public constant hash = 0x564ccaf7594d66b1eaaea24fe01f0585bf52ee70852af4eac0cc4b04711cd0e2;

	constructor() payable {}

	function solve (string memory soluction) public {

		require( hash == keccak256(abi.encodePacked(solution)),"Incorrect answer");

		(bool sent, ) = msg.sender.call{value: 10 ether}("");
		require(sent, "failed to send ether")

	}

}




contract SecuredFindThisHash {
	
	struct Commit {
		bytes32 solutionHash;
		uint256 commitTime;
		bool revealed;
	}

	bytes32 public hash = 0x564ccaf7594d66b1eaaea24fe01f0585bf52ee70852af4eac0cc4b04711cd0e2;

	
	address public winner;

	uint256 public reward;

	bool public ended;

	mapping (address => Commit) commits;

	modifier gameActive(){
		require(!ended, "already ended");
	}

	constructor() payable{
		reward = msg.value;
	}

	function commitSolution(bytes32 _solutionHash) public gameActive {
		Commit storage commit = commit[msg.sender];
		require(commit.commitTime ==0, "Already commited");

		commit.solutionHash = _solutionHash;
		commit.commitTime = block.timestamp;
		commit.revealed = false;
	}

	function revealSolution(string memory _solution, string memory _secret) public gameActive {
		Commit storage commit = commits[msg.sender];
		require(commit.commitTime != 0, "Not commited yet");
		require(commit.commitTime < block.timestamp, "cannot reveal in the same block");

		require(!commit.revealed, "already commited and revealed");

		bytes32 solutionHash = keccak256(abi.encodePacked(msg.sender,_solution, _secret))

		require(solutionHash == commit.solutionHash, "Hash doesnt match");

		require(keccak256(abi.encodePacked(_solution)) == hash, "Incorrect answer	" )


		winner = msg.sender;
		ended = true;

		(bool sent, ) = payable(msg.sender).call{value: 10 reward}("");
		if(!sent){
			winner = address(0);
			ended = false;
			revert("Failed to send ether");
		}
	}

}