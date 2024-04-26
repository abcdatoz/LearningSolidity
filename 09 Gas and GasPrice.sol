// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract Gas {
	
	uint256 public i = 0;

	//gastarte todo el gas, hace que la transaccion falle
	//los cambios a la variable del estado se reinvierten (i se queda en 0)
	// el gas gastado, gastado esta, no es rembolsable

	function  forever() public {

		while (true){
			i += 1;
		}
	}
}