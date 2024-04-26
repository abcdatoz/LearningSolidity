// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;


contract Variables {
	//state variables are stored on the blockchain
	string public text ="hello";
	uint256 public num =123;


	function doSomething() public {
		//local variables are not saved to the blockchain
		uint256 i = 456;

		//here are some global variables
		uint256 timestamp = block.timestamp; // current block timestamp
		address sender = msg.sender; // address of the caller
	}

}