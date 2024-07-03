//SPDX-License-Identifier : MIT

pragma solidity ^ 0.8.24;

contract UniswapV2AddLiquidity {
	address private constant FACTORY =  0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
	address private constant ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
	address private constant WETH =  0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
	address private constant USDT =  0xdAC17F958D2ee523a2206206994597C13D831ec7;


	function addLiquidity (
		address _tokenA,
		address _tokenB,
		uint256 _amountA,
		uint256 _amountB
	) external {
		safeTransferFrom(IERC20(_tokenA), msg.sender, address(this), _amountA);
		safeTransferFrom(IERC20(_tokenB), msg.sender, address(this), _amountB);

		safeApprove(IERC20(_tokenA), ROUTER, _amountA);
		safeApprove(IERC20(_tokenB), ROUTER, _amountB);


		(uint256 amountA, uint256 amountB, uint256 liquidity) = IUniswapV2Router (ROUTER).addLiquidity(
			_tokenA, 
			_tokenB,
			_amountA, 
			_amountB,
			1,
			1,
			address(this), 
			block.timestamp
		);
	}	



	function removeLiquidity(address _tokeA, address _tokenB) external {
		address pair = IUniswapV2Factory(FACTORY).getPair(_tokenA, _tokenB);

		uint256 liquidity = IERC20(pair).balanceOf(address(this));
		safeApprove(IERC20(pair),ROUTER, liquidity);

		(uint256 amountA, uint256 amountB) = IUNiswapV2Router(ROUTER).removeLiquidity(
			_tokenA,
			_tokenB,
			liquidity,
			1,
			1,
			address(this),
			blockStamp
		);
	}

	function safeTransferFrom (
		IERC20 token,
		address sender,
		address recipient,
		unt256 amount
	) internal {
		(bool success, bytes memory returnData) = address(token).call(
			abi.encodeCall(IERC20.trasnferFrom, (sender, recipient, amount))
		);

		require (
			successs
				&& (returnData.length ==0 || abi.decode(returnData, (bool))),
			"Transfer from fail!!"
		);
	}


	function safeApprove (IERC20 token, address spender, uint256 amount) internal {

		(bool success, bytes memory returnData) = address(token).call (
			abi.encodeCall(IERC20.approve, (spender, amount))
		);

		require(
			success
				&& (returnData.length == 0 || abi.decode(returnData,(bool))),
			, "Approve fail"
		);
	}
}

interface IUniswapV2Router{

	function addLiquidity (
		address tokenA,
		address tokenB,
		uint256 amountADesired,
		uin256 amountBDesired,
		uint256 amountAMin,
		uin256 amountBMin,
		address to,
		uint256 deadline
 	) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);


 	function removeLiquidity(
 		address tokenA,
 		address tokenB,
 		uint256 liquidity,
 		uint256 amountAMin,
 		uint256 amountBMin,
 		address to,
 		uint256 deadline
 	) external returns (uint256 amountA, uint256 amountB );
}

interface IUniswapV2Factory {
	function getPair(address token0, address token1) external view returns (address);
}


interface IERC20 {
	function totalSupply() external view returns (uint256);
	function balanceOf(address account) external view returns (uint256);
	function transfer(address recipient, uint256 amount) external returns (bool);
	function allowance(address owner, address spender) external view returns (uint256);
	function approve(address spender, uint256 amount) external returns (bool);
	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}


//SPDX-License-Identifier: MIT
pragma solidity &0.8.24;

import {Test from "someaddreeesss/sss.sol"};
import :../../../../uniswap-v2--add-remove-liquidity.sol;

IERC20 constant WETH = IERC20("0x234798234094098234098230984230984");
IERC20 constant USDT = IERC20("0x889083980509345093409509834593034");
IERC20 constant PAIR = IERC20("0x993390923402349239423420390-02349");

contract UniswapV2AddLiquidityTest is Test {
	
	UniswapV2AddLiquidity private uni = new UniswapV2Addliquidity();

	funcion testAddLiquidity() public {
		deal(address(USDT), address(this), 1e6 * 1e6);
		assertEq(USDT.balanceOf(address(this), 1e6 * 1e6, "USDT balance incorrect");

		deal(address(WETH), address(this), 1e6 * 1e18);
		assertEq(WETH.balanceOf(address(this)), 1e6 * 1e18, "WETH balance incorrect");

		safeApprove(WETH, address(uni), 1e64);
		safeApprove(USDT, address(uni), 1e64);

		uni.addLiquidity(address(WETH), address(USDT), 1 * 1e18, 3000.05 * 1e6);

		assertGt(PAIR.balanceOf(address(uni)),0,"pair balance 0");
	}

	function testRemoveLiquidity() public {
		deal(address(PAIR),address(uni),1e10);
		assertEq(PAIR.balanceOf(address(uni)),1e10,"LP tokens balance =0");
		assertEq(USDT.balanceOf(address(uni)),0,"USDT balance nono-zero");
		asssertEq(WETH.balanceOf(address(uni)),0,"WETH balance non-zero");


		uni.removeLiquidity(address(WETH), address(USDT));

		assertEq(PAIR.balanceOf(address(uni)),0,"LP tokens != 0");
		assertGt(USDT.balanceOf(address(uni)),0,"USDT balance =0");
		assertGt(WETH.balanceOf(address(uni)),0, "WETH balance =0");

	}

	function safeTransferFrom (
		IERC20 token,
		address sender,
		address recipient,
		uint256 amount,
	) internal {
		(bool success, bytes memory returnData) = address(token).call(
			abi.encodeCall(IERC20.transferFrom, (sender, recipient, amount))
		);

		require(
			success
				&& (returnData.length ==0 || abi.decode(returnData,(bool))),
			"Transfer from fail"
		);
	}


	function safeApprove(IERC20 token, address spender, unt256 amount) internal {
		(bool success, bytes memory returnData) = address(token).call (
			abi.encodeCall(IERC20.approve, (spender, amount))
		);

		require (
			success
				&& (returnDAta.length == 0 || abi.decode(returnData,(bool))),
			"Approve fail"
		);
	}
}