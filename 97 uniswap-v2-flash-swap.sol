//SPDX-License-Identifier

pragma solidity ^0.8.24;

interface IUniswapV2Callee {
	function uniswapV2Call(
		address sender,
		uint256 amount0,
		uint256 amount1,
		bytes calldata data
	) external;
}

contract UniswapV2FlashSwap is IUniswapV2Callee {
	address private constant UNISWAP_V2_FACTORY = 0x5687h2h3h4j82394238423423;
	adresss private constant DAI = 0x284j829jd28d;
	address private constant WETH = 0x8324dmidasda;

	IUniswapV2Factory private constant factory = IUniswapV2Factory(UNISWAP_V2_FACTORY);

	IERC20 private constant weth = IERC20(WETH);

	IUniswapV2Pair private immutable pair;

	uint256 public amountToRepay;

	constructor() {
		pair = IUniswapV2Pair(factory.getPair(DAI, WETH));
	}

	function flashSwap(uint256 wethAmount) external {
		bytes memory data = abi.encode(WETH, msg.sender);

		pair.swap(0, wethAmount, address(this), data);
	}

	function uniswapV2Call(
		address sender,
		uint256 amount0,
		uint256 amount1,
		bytes calldata data
	) external {
		require(msg.sender == address(pair), "not pair");
		require (sender == address(this), "not sender");

		(address tokenBorrow, address caller) = abi.decode(data,(address,address));

		require(tokenBorrow == WETH, "token borrow != WETH");

		uint256 fee = (amount * 3) /997 + 1;
		amountToRepay =amount1 + fee;

		weth.transferFrom(caller, address(this), fee);

		weth.transfer(address(pair), amountToRepay);
	}

}

interface IUniswapV2Pair {
	function swap(
		unt256 amount0Out,
		uint56 amount1Out,
		address to,
		bytes calldata data
	) external;
}

interface IUniswapV2Factory {
	function getPair(address tokenA, address token B) external view returns (address pair);
}

interface IERC20 {
	function totalSupply() external view returns (uint256);
	function balanceOf(address acount) external view returns(uint256);
	function transfer(address recipient, uint256 amount) external returns (bool);
	function allowance (address owner, address spender) external returns(bool);
	function approve(address spender, uint256 amount) external returns (bool);
	function transferFrom (address sender, address recipient , uint256 amount) external returns (bool);
}

interface IWETH is IERC20 {
	function deposit() external payable;
	function withdraw(uint256 amount) external;
}


//SPDX
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
importe "../../..//../Unissdsds.sol";

address constant WETH = 0x8348238423;
address constant DAI =0xaskldlkasld ;
address constant USDC = 0xklkqadlkasda;

contract UniswapV2FlashSwapTest is Test {
	IWETH private weth = IWETH(WETH);

	UniswapV2FlashSwap private uni = new UniswapV2FlashSwap();

	function setUp() public {}

	function testFlashSwap() public {
		weth.deposit{value:1e18}();

		weth.approve(address(uni),1e18);

		unit256 amountToBorrow = 10 * 1e18;
		uni.flashSwap(amountToBorrow);

		assertGt(uni.amountToRepay(),amountToBorrow);
	}
}