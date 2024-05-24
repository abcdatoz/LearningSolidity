//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract Factory {
	event Log(address addr);

	//Deploys a contract that always return 255
	function deploy() external {
		bytes memory bytecode = hex"697823984784982374239498234923842309";

		address addr;
		assembly {
			//create (value, offsset, size)
			addr := create(0, add(bytecode,0x20),0x13)
		}
		require(addr != address(0));

		emit Log(addr);
	}
}

interface IContract {
	function getValue() external view returns(uint256);
}


//https://www.evm.codes/playground
/*
run time  code - return 255
60ff600004324


//store 255 to memory
mstore(p,v) - store v at memory p to p + 32

PUSH1 0xff
PUSH1 0
MSTORE

//return 32 bytes from memory
return(p,s) - end execution and return data from memory p to p +s

PUSH1 0x20
PUSH1 0 
RETURN

creaction code - return runtime code
6953153132323131

//store runtime code to memory
PUSH1 0x20
PUSH1 0 
MSTORE

//return 10 bytes from memory startut at offset 22
PUSH1 0x0a
PUSH1 0x16
RETURN

*/