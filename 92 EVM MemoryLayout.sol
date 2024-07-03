//SPDX-License-Identifier: MIT


pragma solidity ^0.8.24;

contract MemBasic {
	
	function test_1() public pure returns (bytes32 b32)	{
		assembly {

			let p := mload (0x40)
			mstore(p, 0xababa)
			b32 := mload(p)
		}		
	}


	function test_2() public pure {
		assembly {
			mstore(0,0x11)
			mstore(1,0x22)
			mstore(2,0x33)
			mstoer(3,0x44)
		}
	}
}


contract MemStruct {
	struct Point {
		uint256 x;
		uint32 y;
		uint32 z;
	}

	function test_read() public pure returns(uint256 x, uint256 y, uint256 z){

		Point memory p = Point(1,2,3);

		assembly {		
			//load 32 bytes starting from 0x80
			x := mload(0x80)
			
			//load32 bytes starting from 0x80 +32 = 0xa0)
			y := mload(0xa0)

			//load 32 bytesstarting from 0xa0 + 32 - 0xc0
			z := mload(0xc0)
		}
	}


	function test_write() public pure returns (bytes32 free_mem_ptr, uint256 x, uint256 y, uint256 z){
		Point memory p;

		assembly {

			mstore(p,11)

			mstore(add(p,0x20),22)

			mstore(add(p,0x40),33)

			free_mem_ptr := mload(0x40)
		}

		x= p.x;
		y =p.y;
		z=p.z;
	}
}



contract MemFixedArray {
	
	function test_read() public pure returns (uint256 a0, uint256 a1, uint256 a2) {

		uint[3] memory arr = [uint32(1), uint32(2), uint32(3)];

		assembly {
			a0 := mload(0x80)
			a1 := mload(0xa0)
			a2 := mload(0xc0)
		}
	}

	function test_write() public pure returns (uint256 a0, uint256 a1, uint256 a2){
		uint32[3] memory arr;

		assembly {
			mstore(arr,11)
			mstore(add(arr,0x20),22)
			mstore(add(arr,0x40),33)
		}

		a0 = arr[0];
		a1 = arr[1];
		a2 = arr[2];
	}
}


contract MemDynamicArray{
	function test_read() public pure returns (bytes32 p, uint256 len, uint256 a0, uint256 a1, uint256 a3) {

		uitn256) memory arr =  new uint256[](5);
		arr[0] = uint256(11);
		arr[1] = uint256(22);
		arr[2] = uint256(33);
		arr[3] = uint256(44);
		arr[4] = uint256(55);


		assembly {
			p := arr
			len:= mload(arr)

			a0 := mload(add(arr,0x20))
			a1 := mload(add(arr,0x40))
			a2 := mload(add(arr,0x60))
		}
	}

	function test_write() public pure returns (bytes32 p, uint256[] memory){
		uint256[] memory arr = new uint256[](0);


		assembly {
			p := arr
			mstore(arr,3)
			mstore(add(arr,0x20),11)
			mstore(add(arr,0x40),22)
			mstore(add(arr,0x60),33)
			mstore(0x40, add(arr,0x80))
		}

		return (p,arr);
	}
}


contract MemInternalFuncReturn {
	
	function internal_func_return_val() private pure returns (uint256){
		return uint256(0xababab);
	}

	function test_val() public pure {
		internal_func_return_val();
	}

	function inernal_func_return_mem() private pure returns (bytes32[] memory){
		bytes32 memory arr = new bytes32[](3);
		arr[0] = bytes32(uint256(0xaaa));
		arr[1] = bytes32(uint256(0xbbb));
		arr[2] = bytes32(uint256(0xccc));

		return arr;
	}


	function test_mem() 
		public
		pure
		returns (uint256 len, bytes32 a0, bytes32 a1, bytes32 a3){

			internal_func_return_mem();

			assembly {
				len := mload(0x80)
				a0 := mload(0xa0)
				a1 := mload(0xc0)
				a2 := mload(0xe0)
			}

		}

}