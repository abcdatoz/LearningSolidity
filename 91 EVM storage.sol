//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract YullIntro {
	
	function test_yul_var() public pure returns (uint256){
		uint256 = 0;

		assembly {
			
			let x:= 1

			x := 2

			s := 2
		}

		return s;
	}

	functions test_yul_types ()
		public 
		pure
		returns (bool x, uint256 y, bytes32 z)
		{

			assembly {
				x := 1
				y := 0xaaa
				z := "Hello yul"
			}

			return (x,y,z);
		}
}


contract  EVMStorageSingletonSlot {
	

	//single variable stored in one slot
	//slot 0
	uint256 public s_x;
	//slot 1
	uint256 public s_y;
	//slot 2
	bytes32 public s_z;


	function test_store() public {
		assembly {
			sstore(0,111)
			sstore(1,222)
			sstore(2,0xababab)
		}
	}

	function test_store_again() public {
		assembly {
			sstore(s_x.slot, 123)
			sstore(s_y.slot, 456)
			sstore(s_z.slot, 0xcdcdcd)
		}
	}

	function test_sload() public view returns (uint256 x, uint256 y, uint256 z) {

		assembly {

			x := sload(0)	
			y := sload(1)
			z := sload(2)
		}

		return (x,y,z);
	}
}



contract EVMStoratePackedSlotBytes {
		bytes4 public b4 =0xabababab;
		bytes2 public b2 - 0xcdcd;

		function get () public view returns (bytes32 b32){
			assembly{
				b32 := sload(0)
			}
		}
}


contract BitMasking {
	
	function test_mask() public pure returns (bytes32 mask){

		assembly {
			mask := sub(shl(16,1),1)
		}
	}


	function test_shift_mask() public pure returns (bytes32 mask){
		assembly {
			mask := shl(32, sub(shl(16,1),1))
		}
	}

	function test_not_mask() public pure returns (bytes32 mask) {
		assembly {
			mask := not(shl(32, sub(shl(16,1),1)))
		}
	}
}


contract EVMStoragePackedSlot {
	uint128 public s_a;
	uint64 public s_b;
	uint32 public s_c'
	uint32 public s_d;

	address public s_addr;

	uint64 public s_x;
	uint32 public s_y;


	function test_sstore() public {
		assembly {

			let v:= sload(0)

			let mask_a := not(sub(shl(128,1),1))
			v := and(v, mask_a)

			v := or (v,11)


			let mask_b := not(shl(128, sun(shl(64,1),1)))

			v := and (v, mask_b)
			v := or (v, shl(128,22))

			let mask_d := not(shl(224, sub(shl(32,1),1)))

			v := and (v, mask_d)
			v := or (v, shl(224,44))
		}
	}
}

