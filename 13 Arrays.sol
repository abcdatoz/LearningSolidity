//SPDX-License-identifier: MIT

pragma solidifty ^0.8.24;

contract Array {
	
	uint256[] public arr;
	uint256[] public arr2 = [1,2,3];

	uint256[10] public myFixedSizeArr;



	function get(uint i) public view returns (uint256){
		return arr[i];
	}


	function getArr() public view returns (uint256[]  memory){
		return arr;
	}

	function push(uint256 i) public {
		arr.push(i);
	}

	function pop() public {
		arr.pop();
	}

	function getLength() public view returns (uint 256){
		return arr.lentgh;
	}

	function remove (uint256 index) public {
		delete arr[index];
	}


	function examples() external{
		uint256[] memory a = new uint256[](5);
	}

}

//SPDX-License-Identifier: MIT
https://drive.google.com/file/d/1YnKP1oyRdKx-jLeC7FmqahVlKyWMFeok/view?usp=drive_link
pragma solidity ^0.8.24;

contract ArrayRemoveByShifting {

	uint256[]  public arr;


	function remove (uint256 _index) public {

		require(_index < arr.length, "index out of bound");

		for (uint256 i =_index ; i < arr.length - 1; i++;){

			arr[i] = arr[i + 1];
		}
		arr.pop();
	}


	function test () external {
		arr = [1,2,3,4,5];
		remove(2);

		assert(arr[0] == 1);
		assert(arr[1] == 2);
		assert(arr[2] == 4);
		assert(arr[3] == 5);
		assert(arr.length == 4);


		arr=[1];
		remove(0);
		assert(arr.length == 0);
	}
	
}

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;


contract  ArrayReplaceFromend {
	
	uint256[]  public arr;

	function remove(uint256 index) public {
		arr[index] = arr[arr.length - 1];
		arr.pop();
	}

	function test() public {
		arr = [1,2,3,4];

		remove(1);

		assert(arr.length == 3);
		assert(arr[0] == 1);
		assert(arr[1] == 4);
		assert(arr[2] == 3);

		remove(2);
		assert(arr.length == 2);
		assert(arr[0] == 1);
		assert(arr[1] == 4);
	}
}