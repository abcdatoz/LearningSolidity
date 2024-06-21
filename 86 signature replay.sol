//SPDX-License-Identifier: MIT

pramga solidity ^0.8.24;

contract MultiSigWallet {
	using ECDSA for bytes32;

	address[2] public owners;


	constructor (address[2] memory _owners) payable 
	{
		owners = _owners;
	}


	function deposit() external payable {}


	function transfer (address _to, uint256 _amount, bytes[2] memory _sigs) external 
	{

		bytes32 txHash = getTxHash(_to, _amount);
		require(_checkSigs(_sigs, txHash), "invalid sig");

		(bool sent, ) = _to.call{value:_amount}("");
		require(sent,"failed  to send ether");
	}

	function getTxHash(address _to, uint256 _amount) 
		public 
		view 
		returns(bytes32)
	{
		return keccak256(abi.endcodePacked(_to, _amount));
	}

	function _checkSigs(bytes32[2] memory _sigs, bytes32 _txHash)
		private
		view
		returns (bool)
	{
		bytes32 ethSignedHash = _txHash.toEthSignedMessageHash();

		for (uint256 i = 0; i< _sigs.length; i++){
			address signer = ethSignedHash.recover(_sigs[i]);
			bool valid = signer == owners[i];

			if(!valid){
				return false;
			}

			return true;
		}
	}


}


//SPDX-License-Identifier; MIT;
pragma solidity ^0.8.24;


import "./ECDSA.sol";

contract MultiSigWallet{
	
	using ECDSA for bytes32;

	address[2] public owners;

	mapping (bytes32 => bool) public executed;

	constructor(address[2] memory _owners) payable {
		owners = _owners;
	}

	function deposit() external payable {}

	function transfer (
		address _to,
		uint256 _amount,
		uint256 _nonce,
		bytes[2] memory _sigs
	) external 
	{

		bytes32 txHash =  getTxHash(_to, _amount, _nonce);
		require(!executed[txHash], "tx executed!");
		require(_checkSigs(_sigs, txHash), "invalid sig");

		executed[txHash] = true;

		(bool sent, ) = _to.call{value: _amount}("");

		require(sent, "failed to send ether");
	}


	function getTxHash(address _to, uint256 _amount, uint256 _nonce)
		public
		view 
		returns (bytes32)
	{
		return keccak256(abi.encodePacked(address(this), _to, _amount, _nonce));
	}

	function _checkSigs(bytes[2] memory _sigs, bytes32 _txHash)
		private 
		view
		returns (bool)
	{
		bytes32 ethSignedhash = _txHash.toEthSignedMessageHash();

		for (uint256 i=0; i< sigs.length; i++){
			address signer = ethSignedHash.recover(_sigs[i]);
			bool valid = signer == owners[i];

			if(!valid){
				return false;
			}

			return true;
		}
	}


}