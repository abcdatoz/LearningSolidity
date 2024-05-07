//SPDX-License-Identifier: MIT

pragma soldity ^0.8.24;


contract Base {
	//private function can only be called inside this contract
	//contracts that inherit ths contract cannot call this function

	function privateFunc() private pure returns (string memory){
		return "private function called";
	}

	function testPrivateFunc() public puer returns (string memory){ 
		return privateFunc();
	}

	//*internal function can be called
	//-inside this contract
	//-inside contracts that inherit this contract
	function internalFunc() internal pure returns (string memory){
		return "internal function called";
	}


	//public function can be called
	//* inside this contract
	//* inside contract that inherit this contract
	//* by other contracts and accounts
	function publicFun() public pure returns (string memory){
		return "public function called";
	}

	//external contracts can be called
	//- by other contracts and accounts
	function externalFunc() external pure returns (string memory) {
		return "external function called";
	}


	//state variables
	string private privateVar = "my private variable";
	string internal internalVar = "my internal variable";
	string public publicVar = "my public variable";

}




contract Child is Base {
	//inherits contracts dont have access to private functons and state //variables

	//function testPrivateFunc () public pure returns (string memory){
	// return privateFunc();
	//}

	function testInternalFunc() public pure override returns (string memory){
		return privateFunc();
	}

} 




/*
function can be declared as

- public:	any contract and account can call
- private:	only inside the contract that defines the function
- internal:	only inside contract that inherits an internal function
- external:	only others contract and accounts can call

state variables can be declared
- public
- private
- interal
-not not external
*/