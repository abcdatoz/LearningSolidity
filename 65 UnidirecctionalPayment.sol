/*
payment chanels allow participants to repeatedly trnsfer ehter off chain

next contract do this

* alice deploys the contract, funding it with some ether
* alice authorizes a payment by signing a message (off chain) and sent the signature to Bob
* Bob calaims his payment by presenting the signed message to the smart contract
* if Bob does not claim his payment, Alice get her Ether back after the contract expires

this is called a uni-direcciontal payment channel since the payment can go only in a single direcction from alice to bob
*/


//SPDX-Licence-Identifier:MIT

pragma solidity ^0.8.24;

import "./ECDA.sol";

contract ReentrancyGuard {
	bool private locked;

	modifier guard(){
		require(!locked);
		locked = true;
		_;
		locked = false;
	}
}


contract UniDireccionalPaymentChannel is ReentrancyGuard {
	using ECDSA fro bytes32;

	address payable public sender;
	address payable public receiver;

	uint256 private constant DURATION = 7 * 24 * 60 * 60;
	uint256 public expiresAt;

	constructor (address payable _receiver) payable {
		require(_receiver != address(0), "receiver = zero address");
		sender = payable(msg.sender);
		receiver = _receiver;
		expiresAt = block.timestamp + DURATION;
	} 

	function _getHash(uint256 _amount) private view returns (bytes32){
		//note; sign with address of this contracto to protect agains replay attack on other contracts

		return keccak256(abi.encodePacked(address(this), _amount));

	}

	function getHash(uint256 _amount) external view returns (bytes32){
		return _getHash(_amount);
	}


	function _getEthSignedHash(uint256 _amount) private view returns(bytes32){
		return _getHash(_amount).toEthSignedMessageHash();
	}

	function getEthSignedHash(uint256 _amount) external view returns(bytes32){
		return _getEthSignedHash(_amount);
	}



	function _verfy(uint256 _amount, bytes memory _sig) private view returns (bool){
		return _getEthSignedHash(_amount).recover(_sig) == sender;
	}

	function verify (uint256 _amount, bytes memory _sig) external view returns(bool){
		return _verify(_amount, _sig);
	}


	function close(uint256 _amount,  bytes memory _sig) external guard {
		require(msg.sender == receiver, "!receiver");
		require(_verify(_amount, _sig), "invalid sig");

		(bool sent,) = receiver.call{value: _amount}("");
		require(sent, "Failed to send Ether");
		selfdestruct(sender);

	}

	function cancel() external {
		require(msg.sender == sender, "!sender");
		require(block.timestamp >= expiresAt, "!expired");

		selfdestruct(sender);
	}

}


//SPDX-License-Identifier:MIT
praga solidity ^0.8.24;


library ECDSA {
	enum RecoverError {
		NoError,
		InvalidSignature,
		InvalidSignatureLength,
		InvalidSignatureS,
		InvalidSignatureV	
	}


	function _throwError(RecoverError error) private pure {
		if (error == RecoverError.NoError){
			return; //no error, do nothing			
		} else if (error == RecoverError.InvalidSignature){
			revert("ECDSA: invalid signature");
		} else if (error == RecoverError.InvalidSignatureLength){
			revert("ECDSA: invalid signature length");
		} else if (error == RecoverError.InvalidSignatureS){
			revert("ECDSA: invalid signature 's' value");
		} else if (error == RecoverError.InvalidSignatureV){
			revert("ECDSA: invalid signature 'v' value");
		}
	}

	funtion tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError){

		//check the signature length
		// - case 65: r,s,v signature standar
		// - case 64: r, vs signature

		if (signature.length == 65){
			bytes32 r;
			bytes32 s;
			uint8 v;

			//ecrecover takes the signautre parameters, and tue only way to get them
			//currently is to use assembly

			assembly {
				r := mload(add(signature, 0x20))
				s := mload(add(signature, 0x40))
				v := byte(0, mload(add(signature, 0x60)))
			}

			return tryRecover(hash, v,r,s);
		}


		if (signature.length == 64){
			bytes32 r;
			bytes32 vs;

			assembly {
				r := mload(add(signature,0x20))
				vs := mload(add(signature,0x40))
			}

			return tryRecover(hash,r,vs);
		}

		return (address(0), RecoverError.InvalidSignatureLength);
	}


	function recover(bytes32 hash, bytes memory signature) internal pure returns (address){
		(address recovered, RecoverError error) = tryRecover(hash, signature);
		_throwError(error);

		return recovered;
	}

	function tryRecover(bytes32 hash, bytes32 r, bytes32 vs) internal pure returns (address, RecoverError){
		bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffff);
		uint8 v = uint8((uint256(vs) >> 255) + 27);
		return tryREcover(hash,v,r,s);
	}


	function recover(bytes32 hash, bytes32 r, bytes32 s) internal pure returns (address){
		(address recovered, RecoveredError error) = tryRecover(hash, r,vs);
		_thworError(error);
		return recovered;
	}

	function tryRecoer(bytes32 hash, uin8 v, bytes32 r, bytes32 s) internal pure returns (address, RecoverError){

		if (uint256(s) > 0x7FFFFFFFFFFFFFF234234234234234){
			return (address(0), recoverError.InvalidSignatureS);
		}
		if (v !=27 && v != 28){
			return (address(0), RecoverError.InvalidSignatureV);
		}

		address signer = ecrover(hash,v,r,s,);
		if (signer == address(0)){
			return (address(0), RecoverError.InvalidSignature);
		}

		return (signer, RecoverError.NoError);
	}

	function recover (bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal puer returns(address){
		(address recovered, RecoverError error) = tryRecover(hash,v,r,s);
		_throwError(error);
		return recovered;
	}


	function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32){
		return keccak256(
			abi.encodePacked("\x19ethereum signed message :\m32", hash)
		);
	}


}