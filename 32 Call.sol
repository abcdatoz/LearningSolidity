//SPDX License-Identidier: MIT

pragma solidity ^ 0.8.24;

contract Receiver {	
	event Received(address caller, uint256 amount, string message);

	fallback() external payable {
		emit Received(msg.sender, msg.value, "Fallback was failed");
	}

	function foo (string memory _message, uint256 _x)
		public
		payable
		returns (uint256)
		{

			emit Received(msg.sender, msg.value, _message);


			return _x + 1;
		}
}



contract Caller {
	event Response (bool success, bytes data);

	function testCallfoo(address payable _addr) public payable {
		(bool success, bytes memory data) = _addr.call {
			value: msg.value,
			gas: 5000
		}(abi.encodeWithSignature("foo(string,uint256)", "call foo", 123));

		emit Response(success,data);
	}


	function testCallDoesNotExist( address payable _addr) public payable {
		(bool success, bytes memory data) = _addr.call{value: msg.value}(
			abi.encodeWithSignature("doesNotExist()")
			);


			emit Response (success, data);
	}


}







/*

Call
calll is a low level function to interact with other contracts

this is recommended method to use when youre just sending ether via calling


however it is not the recommended way to call existing functiona

why not?
* reverts are not bubble up
* type checks are bypassed
* functions existence cheks are omitted
*/

