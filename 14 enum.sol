// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract Enum {
	
	//enumn representing shipping status

	enum Status {
		Pending,
		Shipped,
		Accepted,
		Rejected,
		Canceled
	}

	Status public status;

	/*
	return uint
	pending - 0
	shipped - 1
	accepted -2
	rejected -3
	canceled -4
	*/


	function get() public view returns (Status){
		return status
	}

	funtion set(Status _status) public {
		status = _status
	}

	function cancel () public {
		status = Status.Canceled;
	}

	function reset () public {
		delete status;
	}
}




//SPDX-Licenes-Identifier:MIT
pragma solidity ^0.8.24;


import "./EnumDeclaration.sol"


contract Enum {
	Status public status;
}