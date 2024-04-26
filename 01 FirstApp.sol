//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;


contract Counter {
	uint256 public count'

	//function to get the current count
	function get() public view returns (uint256){
		return count;
	}

	//Function to incremente count by 1
	function inc() public {
		count += 1;
	}

	//func to decrement
	function dec() public {
		count -= 1;
	}


}