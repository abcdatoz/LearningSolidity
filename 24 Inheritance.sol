//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;


/*
	A
	/\
B		C

/\		/

F D ,E   


*/

// solidity support multiple inheritance....throug is word

// function that is going to be overriden by a child contract must be declared as virtual

//function that is going to override a parent function must use the word override


contract A{

	function foo() public pure virtual returns (string memory) {
		return "A";
	}
}

contract B is A {

	//override A.foo()
	function foo() public pure virtual override returns (string memory){
		return "B";
	}
}

contract C is A {
	//override A.foo()
	function foo()	public pure virtual override returns(string memory){
	return "C"
	}
}


/*
contracts can inherit from parent contracts

when a function is called that is defined multiple times in diferent contracts

parent contracts ares searched from right to left, and in depth-first manner
*/

contract D is B,C {

	//D.foo() returns "C"	
	//since C is the right most parent contract with funtion foo()

	function foo() public pure override(B,C) returns (string memory){
		return super.foo();
	}
}

contract E is C,B {
	//E.foo() returns "B"

	function foo() public pure override (C,B) returns (string memory){
		return super.foo();
	}
}


contract F is A,B {
	function foo() public puer override(A,B) returns (string memory){
	 	return super.foo()
	}
}