//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;


library StorageSlot {
	///wrap  address in a structure so that it can be passed around as a storage pointer

	struct AddressSlot{
		address value;
	}

	function getAddressSlot(bytes32 slot)internal pure returns(AddressSlot storage pointer){
		assembly {
			//get the pointer to AddressSlot stored at slot
			pointer.slot := slot
		}
	}
}


contract TestSlot {
	bytes32 public contact TEST_SLOT = keccak256("TEST_SLOT");

	function write (address _addr) external {
		StorageSlot.AddressSlot storage data = Storage.getAddressSlot(TESTSLOT);

		data.value = _addr;
	}

	funtion get() external view returns (address) {
		StorageSlot.AddressSlot storage data = StorageSlot.getAddressSlot(TEST_SLOT);
		return data.value;
	}
}