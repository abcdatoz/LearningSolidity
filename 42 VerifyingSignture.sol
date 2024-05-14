//SPDX:License-Identifier: MIT


pragma solidity ^0.8.24;

/*
hos to sign and verify
#signin
1. create a message to sign
2. hash the message
3. sign the hash (off chaoin, keep your private key secret)


#verify
1. recreate hash from the original message
2. recover signer from signature and hash
3. compare recovered signer to claimed signer
*/


contract VerifiySignature {

	/*
	1. unLock MetaMask account ethereum.enable()

	2. Get MessageHash(0x6237982349849824,123,"coffee and donuts",1)

	hash = "0xcfcfc57c56c767cd88d8cd8"
	*/

	function getMessageHash(
		address _to,
		uint256 _amount,
		string memory _message,
		uint256 _nonce
	) public pure returns (bytes32) {


		return keccak256(abi.encodePacked(_to,_amount,_message,_nonce));

	}

	/*

	3. sing message hash
	#usin browser
		account = "copy paste account of signer here"
		ethereum.request({method: "presonal_sign", params: : [account, hash]}).then(console.log)

	#using web3
		web3.personal.sign(hash, web3.eth.defaultAccount, console.log)

	signature will be different for different accounts
	0x567824092498234092340982309

	*/


	function getEthSignedMessageHas(bytes32 _messageHash) 
		public 
		pure
		returns (bytes32){

		/*
			signature is produced by signin a keccak256 hash with the following format:   "\x19Ethereum signed message \n" + len(msg) + msg
		*/

		return keccak256(abi.encodePacked("\x19Ethereum signed message\m32", _messageHash));


		}


	/*
	4 verify signature
	signer = 0x6239829823982398
	to 0x78234782378423784
	amount - 123
	message = "coffe and donuts"
	nonce =  1
	signature = 0x78324982342
	*/


	function verify (
		address _signer,
		address _to,
		uint256 _amount,
		string memory _message,
		uint256 _nonce,
		bytes memory signature
		) public pure returns(bool){


		bytes32 messageHash = getMessageHash(_to, _amount, _message, _nonce);

		bytes32 ethSignedMessageHash = getEthsSignedMessageHash(messageHash);


		return recoverSigner(ethSignedMessageHash, signature)  == _signer;


		}


		function recoverSigner (
			bytes32 _ethSignedMessageHash,
			bytes memory _signature
		) public pure returns (address) {

			(bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
		}


		function splitSignature(bytes memory sig) public pure returns (bytes32 r, bytes32 s, uint8 v){


			require(sig.length ==65, "Invalid signature length");

			assembly {


				/*
					fitst 32 bytes stores the length of the signature

					add(sig,32) = pointer of sig + 32
					effectively, skips first 32 bytes of signature

					mload(p) loadas next32 bytes starting at the memory address p into memory
				*/

				//first 32 bytes, after thelength prefix
				r := mload(add(sig,32))
				// second 32 bytes
				s:= mload(add(sig,64))
				//final byte (first byte of the next 32 bytes)
				v:= byte(0, mload(add(sig,96)))
			}


			//implicity return (r,s,v)

		}
	
}