//SPDX solidity ^0.8.24;
contract FunctionSelector {
	

	/*
		"transfer(address, uint256)"
		0xa09028js
		"transferFrom(address, address, uint256)"
		0xb23klsdflksdf
	*/


	function getSelector(string calldata _func) external pure returns (bytes4){
		return bytes4(keccak256(bytes(_func)));
	}
}