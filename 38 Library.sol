//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

library Math {
	
	function sqrt(uint256 y) internal pure returns (uint256){
		if(y > 3){
			z = y;
			uint256 x = y / 2+ 1;

			while (x < z){
				z = x;
				x = (y / x + x ) /2;
			}
		}else if ( y != 0){
			z =1;
		}
	}
}



contract Testmath {
	function testSquareRoot(uint256 x) public pure returns (uint256) {
		return Math.sqrt(x);
	}
}


//array function sto delete element at index and reorignaize the array
so that there are no gaps between the elements


library Array {
	function remove(uint256[] storage arr, uint256 index) public {
		//move the las element into the place to delete


		require(arr.length > 0, "cant remove from empty array");
		arr[index] = arr.[arr.length -1];
		arr.pop();
	}	
}


contract Testarray {
	 using Array for uint256[];

	 uint256 public arr;

	 function testArrayRemove() public {
	 	for (uint256 i =0; i <3; i++){
	 		arr.psuh(i);
	 	}

	 	arr.remove(1);

	 	assert(arr.length == 2 );
	 	assert(arr[0] == 0);
	 	assert(arr[1] == 2);
	 }

}




/*

libraies are similar to contracts, but you cant declare any state variable, and you cant send ether

a library is embedded into the contract if all library functions are internal


otherwise the library must be deployed and then linked before the contract is deployed
*/


