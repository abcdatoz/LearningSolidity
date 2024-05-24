//SPDX-License-Identifier:MIT

pragma solidity^0.8.24;

contract Factory {
	//Return the address of the newly deployed contract

	function deploy(address _owner, uint256 _foo, bytes32 _salt)
		public 
		payable
		returns(uint256)
	{
		return address(new TestContract{salt:_salt}(_owner, _foo));
	}
}

//this is the older way of doing it using assembly

contract FactoryAssembly {
	event  Deployed(address addr, uint256 salt);

	//1. Get bytecode of contract to be deployed
	// note: _owner and _foo are arguments of the testContract's constructor

	function getBytecode(address _owner, uint256 _foo)
		public 
		pure
		returns (bytes memory)
	{
		bytes memory bytecode = type(TestContract).creactionCode;

		return abi.encodePacked(bytescode, abi.encode(_owner, _foo));
	};

	//2 Compute the address of the contract to be deployed 
	// note: _salt is a random number used to create an address

	funtion getAddress (bytes memory bytecode, uint256 _salt)
		public
		view
		returns(address)
	{
		bytes32 hash = keccak256(

			abi.encodePacked(
				bytes1(0xff), address(this), _salt, keccak256(bytecode)
			)
		);

		//note: cast last 20 bytes of hash to address
		return address(uint160(uint256(hash)));
	}


	//3 deploy the contract
	//note
	// check the event log deployed which contains the address of the deployed testContract
	// the address in the log should equal the address computed from above

	function deploy (bytes memory bytecode, uint256 _salt) public payable {	
		address addr;

		/*
			Note: how to call create2

			create2(v,p,s)
			create new contract with code at memory p to p +n
			and send v wei
			and return the new address
			where new address = first 20 bytes of keccak256(0xff + address(this) + s+ keccak256(mem[p...(p+n)]))
			s= big -endian 256-bit value

		*/


		assembly {
			addr := 
				create2 (
					callvalue(), //wei sent with current call
					//actual code starts after skipping the first 32 bytes
					add(bytecode, 0x20),
					mload(bytecode),//load the size of code contained in the first 32 bytes
					_salt //salt from function arguments
				)
			
			if iszero(extcodesize(addr)){ revert(0,0)}
		}

		emit Deployed(addr, _salt);
	}

}





contract TestContract {
	address public owner;
	uint256 public foo;

	constructor (address _owner, uint256 _foo) payable {
		owner = _owner;
		foo = _foo;
	}

	function getBalance() public view returns(uint256){
		return address(this).balance;
	}
}


/*

{salt:_salt}
se ocupa para modificar el proceso de creacion de contratos, (creacion de contratos deterministas))
y se ocupa para calcular la direccion del nuevo contrato.
esto permite predecir la direccion del contrato antes de que se implemente realmente


*/