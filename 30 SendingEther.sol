//SPDX License-Identifier: MIT


pragma solidity ^0.8.24;


contract ReceiveEther {


	//Function to receive ether, msg.data must be empty
	receive() external patyable {}

	//Fallback function is called when msg.data is not empty
	fallback() external payable {}
	

	function getBalance() public view returns (uint256){
		return address(this).balance;
	}

}


contract SendEther {

	function sendViaTransfer(address payable _to) public payable {
		//this function is not longer recommended for sending ether

		_to.transfer(msg.value);
	}


	function sendViaSend(address payable _to) public payable {
		//send returns a boolean value indication success or failure
		// this functions is not recommended for sending ether

		bool sent = _to.send(msg.value);
		require(sent, "Failed to send ether");
	}



	function sendViaCall(address payable _to) public payable {
		//call returns a boolean value indicating success or failure
		// this is the current recommended methor to use

		(bool sent , bytes memory data) = _to.call{value: msg.value}("");
		require(sent, "Failed to send ether");
	}
	
}





/*

how to send ether?

you can send ether to other contracts by
* transfer (2300 gas, throws error)
* send (2300 gas, returns bool)
* call (forward all gas or set gas, returns bool)



how to receive this ether?

* receive() external payable
* fallback() external payable


receive() is called if msg.data is empty, otherwise fallback() is called


which method should you use?

call in combination with re-entrancy

*/