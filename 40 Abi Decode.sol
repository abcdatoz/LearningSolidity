//SPDX-License_Identifier: MIT

pragma solidity ^ 0.8.24;


contract AbiDecode {
	
	struct MyStruct {
		string name;
		uint256[2] nums;
	}


	function  encode (
		uint256 x,
		address addr,
		uint256[] calldata arr,
		MyStruct calldata mystruct
		) external pure returns (bytes memory)
	{
		return abi.encode(x, addr,arr, mystruct);
	}


	function decode (bytes calldata data)
		external
		pure 
		returns (uint256 x
				address addr,
				uint256[] memory arr,
				MyStruct memory myStruct
				 )
	 {

	 	(x,addr, arr, myStruct) = abi.decode(data, (uint256, address, uint256[], MyStruct));

	 }



}






/*

abi.Encode encodes data in bytes
abi.Decode decodes bytes back into data


*/