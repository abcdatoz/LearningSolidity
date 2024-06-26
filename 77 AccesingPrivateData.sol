//SPDX-License-Identifier:MIT

pragma solidity ^0.8.24;


constract Vault{

		//slot 0
		uint256 public count =123;
		
		//slot 1		
		address public owner = msg.sender;
		bool public isTrue = true;
		uint16 public u16 = 31;
		
		//slot 2
		bytes32 private password;

		//constant dont use storage
		uint256 public constant someConst =123;

		//slot 3,4,5(one for each array element)
		bytes32[3] public data;

		struct User{
			uint256 id;
			bytes32 password;
		}


		//slot 6 length ogf array
		// stasrting from slot hash(6) --array elements
		// slot where array element is stored = keccak256(slot)) + (index * elementSize)
		User[] private users;

		//slot 7 empty
		//entries are stored at hash(key,slot)
		//where slot = 7, key = map key

		mapping (uint256 => User) private idToUser;

		constructor (bytes32 _password){
			password = _password;
		}

		function addUser(bytes32 _password) public {
			User memory user = User({id: users.length, password = _password });

			users.push(user);
			idToUser[user.id] = user;
		}

		function getArrayLocation(uint256 slot, uint256 index, uint256 elementSize) 
			public 
			pure 
			returns(uint256)
		{
			return uint256(keccak256(abi.encodePacked(slot))) + (index * elementSize);
		}

		function getMapLocation(uint256 slot, uint256 key)
			public 
			pure
			returns (uint256)
		{
			return uint256(keccak256(abi.encodePacked(key, slot)));
		}


}
