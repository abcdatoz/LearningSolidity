//SPDX-License-Identifier: MIT


pragma solidity ^ 0.8.24;

contract HashFunction {
	
	function hash (string memory _text, uint256 _num, address _addr)
		public pure returns (bytes32)
	{

		return keccak256(abi.encodePacked(_text,_num,_addr));

	}


function collision (string memory _text, string memory _anotherText)
	public
	pure
	returns (bytes32)
	{

		return keccak256(abi.encodePacked(_text, _anotherText);
	}
}

contract GuessTheMagicWord {
	bytes32 public answer = 0x45678048230238094098248028482940929482384092394234923092340


	function guess (string memory _world) public view returns (bool){
		return keccak256(abi.encodePacked(_world))  == answer;
	}
}




/*

keccak256 computes the lecat-256 hash of the input

some use cases are:

	* creating deterministic unique id from an input
	* commit-revea; schema
	* compact cryptographic signature 
*/