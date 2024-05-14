//example of how to declare variables inside assembly


//SPDX--License-Identifier: MIT

pragma solidity ^0.8.24;

contract AssemblyVariable {
	
	function yul_let () public pure returns (uint256){
		assembly {
			//language used for assembly is called yul
			//local variables

			let x:= 123

			z := 456
		}
	}
}