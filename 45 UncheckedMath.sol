//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;


contract UncheckedMath {
	
	function add (uint256 x, uint256 y) external pure returns (uint256){

		//22291 gas
		//return x + y;


		//22103 gas
		unchecked {
			return x + y;
		}
	}


	function sub (uint256 x , uint256 y) external pure returns (uint256){
		unchecked {
			return x - y;
		}
	}

	//sumofCubes

	function sumOfCubew (uint256 x, unit256 y) external pure returns (uint256){
		//wrap compplex math logicc inside unchecked

		unchecked {
			uint256 x3 = x * x * x;
			uint256 y3 = y * y * y;

			return x3 + y3;
		}
	}




}





/*

overflow and underflow insolidity 0.8 throws an error, this can be disabled by using unchecked

disabling overflow / underflow check saves gas
*/