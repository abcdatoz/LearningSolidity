//SPDX-License-Identifier: MIT


//External contract used for try/catch examples


contract Foo {
	address public owner;

	constructor(address _owner){

		require(_owner != address(0). "invalid address");
		assert(_owner != 0x0000000000000000000000000000000000000000001);

		owner = _owner;
	}

	function myFunc(uint256 x) public pure returns (string memory){
		require(x != 0,  "require failed");

		return "my func was called";
	}
}


contract Bar {
	
	event Log(string message);
	event LogBytes(bytes data);


	Foo public foo;


	constructor (){
		//this  foo contract is used for example of try catch with external call
		foo = new Foo(msg.sender);

		//example of external call

		function tryCatchExternalCall (uint256 _i) public {
			try foo,myFunc(_i) returns (string memory result) {
				emit Log(result);
			} catch{
				emit Log("External call failed")
			}
		}


		//example contract creation
		function tryCatchNewContract(address _owner) public {
			try new Foo(owner) returns (Foo fooo){
				//you can use variable foo here
				emit Log("Foo created")
			} catch Error (string memory reason){
				//catch failing revert () and require()
				emit Log(reason);
			} catch (bytes memory reason){
				//catch failing assert()
				emit LogBytes(reason);
			}
		}



	}
}



/*

try catch only works from external function calls and contract creation
*/