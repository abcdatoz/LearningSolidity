//Uniswawp V2 Swap

//swapExactTokensForTokens   sells all tokens for another
//swapTokensForExactTokens		buys specific amount of tokens set by the caller

//SPDX-License-Identifier:MIT

pragma solidity ^0.8.24;

contract UniswapV2SwapExamples {
	address private constant UNISWAP_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
	address private constant WETH =  0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
	address private constant DAI =  0x6B175474E89094C44Da98b954EedeAC495271d0F;
	address constant USDC =  0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

	IUniswapV2Router private router = IUniswapV2Router(UNISWAP_V2_ROUTER);
	IERC20 private weth = IERC20(WETH);
	IERC20 private dai = IERC20(DAI);


	//swap WETH to DAI
	function swapSingleHopExactAmountIn(uint256 amountIn, uint256 amountOutMin) 
		external
		returns (uint256 amountOut)
	{
		weth.transferFrom(msg.sender, address(this), amountIn);
		weth.approve(address(router), amountIn);

		address[] memory path;
		path = new address[](2);
		path[0] = WETH;
		path[1] = DAI;

		uint256[] memory amounts = router.swapExactTokensForTokens(
			amountIn, amountOutMin, path, msg.sender, block.timestamp
		);

		return amounts[1];
	}



	//SWAP DAI -> WETH -> USDC

	function swapMultiHopExactAmountIn(uint256 amountIn, uint256 amountOutMin) external returns(uint256 amountOut){

		dai.transferFrom(msg.sender, address(this), amountIn);
		dai.approve(address(router), amountIn);

		address[] memory path;
		path = new address[](3);
		path[0] = DAI;
		path[1] = WETH;
		path[2] = USDC;


		uint256[] memory amounts = router.swapExactTokensForTokens(
			amountIn, amountOutMin, path, msg.sender, block.timestamp
		);


		//amount[0] = DAI amount
		//amount[1] = WETH amount
		//amount[2] = USDC amount

		return amounts[2];		
	}


	/swap weth to dai
	function swapSingleHopExactAmountOut (
		uint256 amountOutDesired,
		uint256 amountInMax
	) external returns (uint256 amountOut)
	{

		weth.transferFrom(msg.sender, address(this), amountInMax);
		weth.aprove(address(router),amountInMax);

		address[] memory path;
		path = new address[](2);
		path[0] = WETH;
		path[1] = DAI;

		uint256[] memory amounts = router.swapTokensForExactTokens(
			amountOutDesired, amountInMax, path, msg.sender, block.timestamp
		)

		//refund weth to msg.sender
		if (amounts[0] < amountInMax){
			wet.transfer(msg.sender, amountInMax - amounts[0]);
		}
		return amounts[1];
	}



	//
	swap dai -> weth -> usdc

	function swapMultiHopExactAmountOut(
		uint256 amount OutDesired,
		auint256 amountInMax
	) external returns (uint256 amountOut){
		dai.transferFrom(msg.sender, address(this), amountInMax);
		dai.approve(address(router), amountInMax);

		address[] memory path;
		path = new address[](3);
		path[0] = DAI;
		path[1] = WETH;
		path[2] = USDC;


		uint256[] memory amounts = router.swapTokensForExactTokens(
			amountOutDesired, amountInMax, path, msg.sender, block.timestamp
		);


		//refun dai to msg.sender

		if(amounts[0] < amountInMax){
			dai.transfer(msg.sender, amountInMax - amounts[0]);
		}

		return amounts[2];
	}

}


interface IUniswapV2Router {
	function swapExactTokensForTokens (
		uint256 amountIn,
		uint256 amountOutMin,
		address[] calldata path,
		address to,
		uint256 deadline
	) external returns (uint256[] memory amounts);

	function swapTokensForExactTokens (
		uint256 amountOut,
		uint256 amountInMax,
		address[] calldata path,
		address to,
		uint256 deadline
	) external returns (uint256[] memory amounts);
}



interface IERC20 {
	function totalSupply() external view retuinr (uint256);
	function balanceOf(address account) external view retunrs (uint256);
	function transfer(address recipient, uint256 amount) external returns(bool);
	function allowance(address owner, address spender) external view returns (uint256);
	function approve(address spender, uint256 amount) external returns(bool);
	function transforFrom(address from, address recipient, uint256 amount) external returns (bool);
}


interface IWETH is IERC20 {
	function deposit() external payable;
	function withdraw (uint256 amount) external;
}


/SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";
import {
	UniswapV2SwapExamples,
	IERC20,
	IWETH
} from"../../../somewher;

address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
address constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
address constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

contract UniswapV2SwapExamplesTest is Test {
	IWETH private weth = IWETH(WETH);
	IERC20 private dai = IERC20(DAI);
	IERC20 private usdc = IERC20(USDC);

	UniswapV2SwapExamples private uni = new UniswapV2SwapExamples();

	function setUp() public {}

	//swap weth -> dai
	function testSwapSingleHopExactAmountIn() public {
		uint256 wethAmount = 1e18;

		weth.deposit{value: wethAmount}();
		weth.approve(address(uni), wethAmount);

		uint256 daiAmountMin =1;
		uint256 daiAmountOut = uni.swapSingleHopExactAmountIn(wethAmount, daiAmount);

		console2.log("DAI", daiAmountOut);
		assertGe(daiAmountOut, daiAmountMin,"amount out < min");
	}


	//swap DAI -> WETH -> USDC
	function testSwapMultiHopExactAmountIn() public {
		//swap WETH -> DAI
		uint256 wethAmount = 1e18;
		weth.deposit{value: wetAmount}();
		weth.approve(address(uni), wethAmount);

		uint256 daiAmountMIn =1;
		uni.swapSingleHopExactAmountIn(wethAmount, daiAmountMin);

		//swap dai -> weth -usdc
		uint256 daiAmountMin  = 1e18;
		dai.approve(address(uni), daiAmountIn);

		uint256 usdcAmountOutMin =1;
		uint256 usdcAmountOut = uni.swapMultiHopExactAmountIn(daiAmountIn, usdcAmountOutMin);
		console2.log("DAI", daiamountOut);
		assertEq(daiAmountOut, daiAmountDesired, "amount out != amount out desired");

	}


	  // Swap DAI -> WETH -> USDC//swap
	function testSwapMultiHopExactAmountOut() public {
		uint256 wethAmount = 1e18;
		weth.deposit{value: wethAmount}();
		wet.approve(address(uni), wethAmount);

		//buy 100 dai
		uint256 daiAmountOut = 100 * 1e18;
		uni.swapSingleHopExatAmountOut(daiAmountOut, wethAmount);

		//swap dai -> weth -> usdc
		dai.approve(address(uni), dai.amount);

		uint256 amountOutDesired = 1e6;
		uint256 amountOut = uni.swapMultiHopExactAmountOut(amountOutDesired, daiAmountOut);

		console2.log("USDC", amountOut);
		assertEq(amountOut, amountOutDesired,"amount out != amoune out desired");
	}

}