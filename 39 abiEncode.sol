// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;
 

interface IRC20 {
	function trnasfer (address , uint256) external;
}


contract Token{
	function transfer(address, uint256) external{}	
}

contract AbiEncode {
	function test(address _contract, bytes calldata data) external {
		(bool ok,) = _contract.call(data);

		require("ok", "call failed");
	}

	function encodeWithSignature(address to, uint256 amount) 
		external 
		pure 
		returns (bytes memory) 
	{

		return abi.encodeWithSignature("transfer(address, uint256)",to, amount);

	}


	function encodeWithSelector(address to, uint256 amount)
		external
		pure
		returns (bytes memory)

	{

		//type is not checked - (IERC20.transfer.selector,true, amount)
		return abi.encodeWithSelector(ERC20.transfer.selector,to,amount);
	}

	function encodeCall (address to, uint256 amount)
		external
		pure
		returns (bytes memory)
	{

		return abi.encodeCall(IERC20.trasnfer, (to, amount));

	}




}


