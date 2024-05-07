//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract A {
	string public name = "Contract A"

	function getName() public view returns (string memory){
		return name;
	}
}


//shadowing is disallowed in Solidity0.6
//this will not compile

//contract B is A {
//	  string public name = "contract B"
//}

contract C is A {
	//this is the correct  way to override

	constructor (){
		name = "Contract C"
	}
}




// a diferencia de las funciones , las variables de estado no pueden ser sobre escritas en un contrato hijo