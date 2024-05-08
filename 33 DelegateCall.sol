//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;



//Note: Deploy this contract first
contract B {

	//Note: storage layout must be the same as contract A
	uint256 public enum;
	address public sender;
	uint256 public value;

	function setVars(uint256 _num) public payable {
		num = _num;
		sender = msg.sender;
		value = msg.value;
	}	
}

contract A {
	uint256 public num;
	address public sender;
	uint256 value;

	function setVars (address _contract, uint256 _num) public payable {
		//A-s storage is set, B is not modified

		(bool success, bytes memory data) = _contract.delegatecall(
		abi.encodeWithSignature("setVars(uint256"),_num);
	}
}





/*

DelegateCall is a low level function similar to call

when contract A executes delegatecall to contract B, Bs code is executed


with contracts'A storage, msg.sender and msg.value
*/