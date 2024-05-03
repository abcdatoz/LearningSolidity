// SPDX-License-Identifier:  MIT

pragma solidity ^0.8.24;


contract Error {


	function testRequire(uint256 _i) public pure {
		//require should be used to validate conditions such as :
		// - inputs
		// - conditions before execution
		// - return values from call to other functions

		require(_i > 10, "Input must be greater than 10")
	}


	function  testRevert(uint256 _i) public pure {
		//revert is useful when conditions to check is compex
		// this code does the exact saem thing as the excample above


		if (_i <=10){
			revert("input must be greater than 10!!")
		}
	}

	uint256 public num;

	function testAssert() public view{
		//assert should only be used to test for internal errors, and to check invariants

		//here we assert that num is always equel to 0
		//since it is impossible to update the value of num

		assert(num == 0)
	} 


	//custom error
	error InsufficientBalance(uint256 balance, uint256 withdrawAmount);

	function testCustomError(uint256 _withdrawAmount) public view {
		uint256 bal = address(this).balance;

		if (bal < _withdrwaAmount){

			revert InsufficientBalance({
				balance: bal,
				withdrawAmount: _withdrawAmount
			});
		}
	}
	
}




//another example
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract Account {
	uint256 public balance;
	uint256 public constant MAX_UINT = 2 **256 -1;


	function deposit(uint256 _amount) public {
		uint256 oldBalance = balance;
		uint256 newBalance = balance + _amount;


		require (newBalance >= oldBalance, "overflow")

		balance = newBalance;

		assert(balance >= oldBalance);
	}


	function withdraw(uint256 _amount) public {
		uint256 oldBalance = balance;


		require(balance >= _amount, "underflow");


		if (balance < _amount){
			revert("underflow")
		}

		balance -= _amount;

		assert (balance <= oldBalance)
	}



}













/*

an error will undo all changes made to the state during a transaction


you can throw an error by calling require, revert or assert

* require is used to validate inputs and conditions before execution
* revert is similar to require. see the code below for details 
* assert ms used to check for code that should never be false. failing assertion probably meas that there is a bug.

*/