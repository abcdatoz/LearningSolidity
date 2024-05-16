/*
ERC20

any contract that follow the erc20 standard is a erc20 token

erc20 tokens provide functionalities to
	* transfer tokens
	* allow others to transfer tokens on behalf of the token holder
*/

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

interface IRC20 {
	function totalSupply() external view returns (uint256);
	function balanceOf(address account) external view returns (uint256);
	function transfer(address recipient, uint256 amount) external returns (bool);
	function allowance (address owner, address spender) external view returns (uint256);
	function approve (address spender, uint256 amount) external returns (bool);
	function transferFrom(address sender, address recipient, uint256 amount) external returns(bool);
}


//example of ERC20 contract

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./IERC20.sol"

contract ERC20 is IERC20 {
	
	event Transfer(address indexed from, address indexed to, uint256 value);
	event Approval (address indexed owner, address indexed spender, uint256 value);


	uint256 public totalSuply;
	mapping(address => uint256) public balanceOf;
	mapping(address => mapping(address => uint256)) public allowance;
	string public name;
	string public symbol;
	uint8 public decimals;

	constructor (string memory _name, string memory _symbol, uint8 _decimals){
		name = _name;
		symbol = _symbol;
		decimals = _decimals;
	}


	function tranfer (address recipient, uint256 amount) external returns(bool){
		balanceOf[msg.sender] -= amount;
		balanceOf[recipient] += amount;

		emit Transfer(msg.sender, recipient, amount);
		return true;
	}


	function approve(adderss spender, uint256 amount) external returns (bool){
		allowance[msg.sender][spender] = amount;
		emit Approval(msg.sender, spender, amount);
		return true;
	}

	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool){
		allowance[sender][msg.sender] -= amount;
		balanceOf[sender] -= amount;
		balanceOf[recipient] += amount;
		emit Transfer(sender, recipient, amount);
		return true;
	}

	function _mint(address to, uint256 amount) internal {
		balanceOf[to] += amount;
		totalSupply += amount;
		emit Transfer(address(0),to, amount);
	}

	function _burn(address from, uint256 amount) internal {
		balanceOf[from] -= amount;
		totalSupply -= amount;
		emit Transfer(from, address(0), amount);
	}

	function mint(address to, uint256 amount) external {
		_mint(to, amount);
	}

	function burn(address from, uint256 amount) external {
		_burn(from, amount);
	}
}



//using open zepellin its really easy to create your own erc20 token
//here an example

//SPDX-License-Identifier: MIT
pramga solidity 0.8.24;

import "./ERC20.sol"

contract MyToken is ERC20 {
	
	constructor( string memory name, string memory symbol, uint8 decimals) ERC20(name, symbol, decimals){
		//mint 100 tokens to msg.sender
		//similar to how
		//1 dolar = 100 cents
		//1  token = 1 *(10 ** decimals)

		_mint(msg.sender, 100 * 10 ** uint256(decimals));
	}
}


//Contract to swap tokens
/*
 here is an example contract, tokenswap, to trade one erc20 token for another

transferFrom (address sender, address recipient, uint256 amount)
for transferFrom to succed, sender must

* have more than amount tokens in ther balance
* allowed tokenswap to withdraw amount tokens by calling approve

prior to tokenswap calling transferFrom 

*/


//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./IERC20.sol"

/*
How to swap tokens

1. Alice has 100 tokens from aliceCoin, which is a ERC20 token
2. Bob has 100 tokens from bobCoin, which is alsoa ERC20 token
3. Alice and Bob wnats to trade 10 AliceCoin for 20 BobCoin
4. Alice or Bob deploys TokenSwap
5. Alice approves TokenSwap to withdraw 10 token from AliceCoin
6. Bob approves TokenSwap to withdraw 20 token from BobCoin
7. Alice or Bob calls TokenSwap.swap()
8. Alice or Bob traded tokens successfully.

*/


contract TokenSwap {
	IERC20  public token1;
	address public owner1;
	uint256 public amount1;

	IERC20  public token2;
	address public owner2;
	uint256 public amount2;

	constructor (
		address _token1,
		address _owner1,
		uint256 _amount1,
		address _token2,
		address _owner2,
		uint256 _amount2
	){

		token1 = IERC(_token1);
		owner1 = _owner1;
		amount1 = _amount1;

		token2 = IERC(_token2);
		owner2 = _owner2;
		amount2 = _amount2;
	}


	function swap() public {

		require(msg.sender == owner1 || msg.sender == owner2, "Not authorized!!");
		require(token1.allowance(owner1, address(this)) >= amount1, "Token 1 allowance too low");
		require(token2.allowance(owner2, address(this)) >= amount2, "Token 2 allowance too low");

		_safeTransferFrom (token1, owner1, owner2, amount1);
		_safeTransferFrom (token2, owner2, owner1, amount2);

	}

	function _safeTransferFrom (
		IERC20 token,
		address sender,
		address recipient, 
		unint256 amount 
		) private {
			bool sent = token.trnsferFrom(sender, recipient, amount);
			require (sent, "token tranfer failed!!");
		}

}