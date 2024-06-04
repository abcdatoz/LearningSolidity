//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract MultiDelegateCall {
	
	error DelegateCallFailed();

	function multiDelegateCall(bytes[] memory data)
		external
		payable
		returns (bytes[] memory results)
	{
		results = new bytes[](data.length)

		for (uint256 i =0; i < data.length; i++){
			(bool ok, bytes memory res) = address(this).delegateCall(data[i]);
			if(!0k){
				revert DelegateCallFailed();
			}
			results[i] = res;
		}
	}
}

contract TestMultiDelegatecall is MultiDelegateCall {
	event Log (address caller, string func, uint256 i);

	function func1 (uint256 x, uint256 y) external {
		emit Log(msg.sender, "func 1", x + y);
	}

	function func2 () external returns (uint256){
		emit Log(msg.sender, "func 2",2);
		return 111;
	}

	mapping(address => uint256) public balanceOf;

	function mint() external payable {
		balanceOf[msg.sender] += msg.value;
	}
}

contract Helper {
	function getFunc1Data(uint256 x, uint256 y)
		external
		pure
		returns (bytes memory)
	{
		return abi.encodeWithSelector(TestMultiDelegateCall.func1.selector, x, y);
	}

	function getFunc2Data() external pure returns (bytes memory){
		return abi.encodeWithSelector(TestMultiDelegateCall.fun2.selector);
	}

	function getMintData () external pure returns (bytes memory){
		return abi.encodeWithSelector (TestMultiDelegatecall.mint.selector)
	}
}