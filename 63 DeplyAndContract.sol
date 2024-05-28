//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract Proxy {
	event Deploy(address);

	receive() external payable {}

	function deploy(bytes memory _code) external payable returns (address addr){

		assembly {
			//create (v,p,n)
			// v = amount of ETH to send
			// p = pointer in memory to start code
			// n = size of code

			addr := create ( callvalue(), add(_code,0x20), mload(_code))
		}

		require(addr != address(0), "deploy failed");

		emit Deploy(addr);
	}


	function execute(address _target, bytes memory _data) external payable {
		
		(bool success,) = _target.call{value: msg.value}(_data);

		require(success,"failed")
	}
}



contract TestContract1 {
	address public owner = msg.sender;

	function setOwner(address _owner) public {
		require(msg.sender == owner, "not owner");
		owner = _owner;
	}
}

 
contract TestContract2 {
	address public owner = msg.sender;
	uint256 public value = msg.value;
	uint256 public x;
	uint256 public y;

	constructor (uint256 _x, uint256y) payable {
		x =_x;
		y =_y;
	}

}


contract Helper {
	function getBycode1() external pure returns (bytes memory){
		bytes memory bytecode = type(testContract1).creationCode;
		return bytecode;
	}

	function getBycode2(uint256 _x, uint256 _y) external pure returns (bytes memory){
		bytes memory bytecode = type(TestContract2).creationCode;
		return abi.encodePacked(bytecode, aby.encode(_x,_y));
	}

	function getCalldata(address _owner) external pure returns (bytes memory) {
		return abi.encodeWithSignature("setOwner(address", _owner);
	}
}






/*
deploy any contract by calling Proxy.deploy(bytes memory _code)
*/