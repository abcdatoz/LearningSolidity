// SPDX-License-Identifier: MIT


pragma solidity ^0.8.24;

contract FunctionModifier {
	
	address public owner;
	uint256 public x = 10;
	bool public locked;

	constructor () {
		owner = msg.sender;
	}


	//modifier to check that the caller is the owner of the contract 


	modifier onlyOwner(){
		require(msg.sender == owner, "Not owner");

		//underscore is a special character only used inside a function modifier and it tells solidity to execute the rest of the code

		_;

	}


	modifier validAddress (address _addr){
		require(_addr != address(0), "not valid address!!")
		_;
	}


	function changeOwner(address _newOwner) 
		public 
		onlyOwner 
		validAddress(_newOwner)
	{
		owner = _newOwner;

	}



	//modifiers can be called before and or after function
	//this modifier prevents a function from being called while it is //still executing

	modifier noReentrancy(){
		require(!locked, "No reentrancy")

		locked = true;

		_;

		locked = false;
	}


	function decrement (uint256 i) public noReentrancy {
		x -= i;

		if (i > 1){
			decrement(i -1);
		}
	}


}




/*

modifier are code that can be run before and or after a function call

modifier can be used to
-restrict access
-validate inputs
-guard against reentrancy hack
*/