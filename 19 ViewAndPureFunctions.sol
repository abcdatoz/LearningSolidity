// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24

contract ViewAndPure {
	
	uint256 public x =1;


	//this not modify the state
	function addToX(uint256 y) public view returns(uint256){
		return x + y;
	}

	//this dont modify or read from the state


	function add(uint256 j, uint256 k) public pure returns(uint256){
		return j + k;
	}


}


/*
Getter functions can be declared view or pure

view function declares that no state will b changed

pure function declares that no states variable will be changed or read
*/