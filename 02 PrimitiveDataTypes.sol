//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Primitives {

	bool public boo = true;
	/*
		unit stands for unsigned integer, meaning non negative integeres
		different sizes ara available

		uint8 	ranges from 0 to 2**8 - 1		| 0-255
		uint16 	ranges from 0 to 2**16 - 1	| 0-65,535
		unint32 ranges from 0 to 2**32 -1	| 0- 4,294,967,296
		uint256 ranges from 0 to 2**256 -1
	*/

	uint8 public u8 =1;
	uint256 public u256 =456;
	uint256 public u =123;


	/*
	negative numbers are allowed for int types
	like uint, different ranges are availabel from int8 to int256

	int256 ranges from -2 **255 to 2 ** 256 -1 
	int128 ranges from -2 **127 to 2 *127 -1 
	*/

	int256 public minInt = type(int256).min;
	int256 public maxInt = type(int256).max;

	address public addr = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;

	/*
		in solidity, the data type byte represent a sequence of bytes
		solidity presents two type ob bytes types:



		- fixed-sized byte arrays
		- dynamically-sized byte arrays

		the term bytes in solidity represents a dynamic array of bytes
		its a shothand  of byte[]

	*/

	bytes1 a = 0xb5; //[10110101]
	bytes1 b = 0x56; //[01010110] 

	//default values
	//unassigned variables have default value

	bool public defaultBoo;//false
	uint256 public defaultUint; //0
	int256 public defaultInt;//0
	address public defaultAddress;//0x000000000000000000000000000000000



}