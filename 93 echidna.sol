//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract Counter {
	uint256 public count;

	function inc() external {
		count += 1;
	}

	function dec() external {
		count -= 1;
	}
}

contract TestCounter is Counter {
	
	function echidna_test_true() public view returns (bool){
		return true;
	}

	function echidna_test_false() public view returns (bool){
		return false;
	}

	function echidna_test_count() public view returns (bool){
		return count <= 5;
	}
}



contract TestAssert {
	function test_assert(uint256 _i) external {
		assert(_i < 10);
	}

	function abs(uint256 x, uint256 y) private pure returns (uint256){

		if(x >= y){
			return x - y;
		}

		return y - x;
	}

	function test_abs(uint256 x, uint256 y) external {
		uint256 z =abs(x,y);

		if(x >= y){
			assert(z <= x);
		}else{
			assert(z <= y);
		}
	}
}



Contract EchidnaTestTimeCaller {
	bool private pass = true;
	uint256 private createdAt = block.timestamp;

	function echidna_test_pass() public view returns(bool){
		return pass;
	}

	function setFail() external {
		uint256 delay = 7 days;
		require(block.timestamp >= createdAt + delay);
		pass = false;
	}

	address[3] private senders = [address(0x10000), address(0x20000), address(0x30000)];

	address private sender = msg.sender;


	function setSender(address _sender) external {
		require(_sender == msg.sender);
		sender = msg.sender;
	}


	function echidna_test_sender() public view returns (bool) {
		for (uint256 i; i < 3; i++){
			if(sender == senders[i]){
				return true;
			}
		}
		return false;
	}

}