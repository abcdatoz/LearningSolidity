//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24

contract SimpleStorage {
	
	uint256 public numero;


	//it cost
	function set (uint256 _num){
		numero = _num;
	}


	//there is no cost to read
	function get()public view returns (uint256){
		return numero;
	}

}

/*

To write or update a state variable you need to send a transaction.

On the other hand, you can read state variables, for free, without any transaction fee.

*/