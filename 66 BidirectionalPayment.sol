//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./ECDSA.sol";



contract BiDirectionalPaymentChannel {
	using ECDSA for bytes32;

	event ChallengeExit(address indexed sender, uint256 nonce);
	event Withdraw(address indexed to, uint256 amount);

	address payable[2] public users;
	mapping (address => bool) public isUser;
	mapping (address => uint256) public balances;

	uint256 public challengePeriod;
	uint256 public expiresAt;
	uint256 public nonce;

	modifier checkBalances(uint256[2] memory _balances){
		require (
			address(this).balance >= _balances[0] + _balances[1],
			"balance of contract must be >= to the total of balance of users"
		);
		_;
	}

	//note: deposit from multi-sig wallet
	constructor (
		address payable[2] memory _users,
		uint256[2] memory _balances,
		uint256 _expiresAt,
		uint256 _challengePeriod
		) payable checkBalances(_balances)
	{

		require(_expiresAt > block.timestamp, "expiration must be > now");
		require(_challengePeriod > 0, "Challenge period must be > 0");

		for (uint256 i = 0; i < _users.length; i++){
			address payable user = _user[i];

			require(!isUser[user], "user must be unique");
			users[i] = user;
			isUser[user]  = true;

			balances[user] = _balances[i]
		}

		expiresAt = _expiresAt;
		challengePeriod = _challengePeriod;
	}

	function verify (
		bytes[2] memory _signatures,
		address _contract,
		address[2] memory _signers,
		uint256[2] memory _balances,
		uint256 _nonce
	) public pure returns (bool)
	{
		for (uint256 i=0; i < _signatures.length; i++){
			//note: sign with the address of this contract to protect against replay attack on other contract

			bool valid = _signers[i] = keccak256(abi.encodePacked(_contract, _balances, _nonce)).toEthSignedMessageHash().recover(_signatures[i]);

			if(!valid){
				return false;
			}
		}

		return true;
	}

	modifier checkSignatures(
		bytes[2] memory _signatures,
		uint256[2] memory _balances,
		uint256 _nonce
	){
		//note : copy storage array to memory

		address[2] memory signers;
		for (uint256 i =0; i < users.length; i++){
			signers[i] = users[i];
		}

		require(
			verify(_signatures, address(this), signers, _balances, _nonce),
			"invalid signature"
		);
	}

	modifier onlyUser(){
		require(isUser[msg.sender],"not user");
	}

	function challengeExit (
		uint256[2] memory _balances,
		uint256 _nonce,
		bytes[2] memory _signatures
	) public 
		onlyUser
		checkSignatures(_signatures,_baances, _nonce),
		checkBalances(_balances)
	{

		require(block.timestamp >= expiresAt,"expired challenge period");
		require(_nonce > nonce, "nonce must be greater than the current nonce");

		for (uint256 i=0; i<_balances.length;i++){
			balances[users[i]] = _balances[i];
		}

		nonce = _nonce;
		expiresAt = block.timestamp + challengePeriod;

		emit ChallengeExit(msg.sender, nonce);

	}

	function withdraw() public onlyUser {
		require (block.timestamp <= expiresAt, "challenge period has not expiret yet");

		uint256 amount = balances[msg.sender];
		balances[msg.sender] = 0;

		(bool sent ,) = msg.sender.call{value: amount}("");
		require (sent, "failed to send ehter");

		emit Withdraw(msg.sender, amount);
	}
}


//SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

library ECDSA {
	enum RecoverError {]}
}