//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;


contract Callee {
	uint256 public x;
	uint256 public value;

	function setX(uint256 _x) public returns (uint256){
		x = _x;
		return x;
	}

	function setXandSendEther(uint256 _x)
		public 
		payable 
		returns (uint256, uint256)
	{

		x = _x;
		value = msg.value;

		return (x, value);


	}

}


contract Caller {
	function setX(Callee _callee, uint256 _x){
		uint256 x = _callee.setX(_x);
	}


	function setXFromAddress(address _addr, uint256 _x) public {
		Callee callee = Callee(_addr);

		callee.setX(_x);
	}


	function setXandSendEther(Callee _callee, uint256 _x) public payable {
		(uint256 x, uint256 value) = _callee.setXandEther{value: msg.value}(x);
	}
}




/*

contract can call other contracts in 2 ways

the easiest way to is to just call it, like  A.foo(x,y,z)

another way to call  is using call
*/