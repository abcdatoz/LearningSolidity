//SPDX-License-Identifier:MIT

pragma solidity ^0.8.24;

contracty UniswapV3Flash {
	struct FlashCalbackData{
		uint256 amount0;
		uint256 amount1;
		address caller;
	}


	IUniswapV3Pool private immutable pool;
	IERC20 private immutable token0;
	IERC20 private immutable token1;


	constructor (address _pool){
		pool = IUniswapV3Pool(_pool);
		token0 = IERC20(pool.token0());
		token1 = IERC20(pool.token());
	}


	function flash(uint256 amount0, uint256 amount1) external {
		bytes memory data = ab.encode(
			FlashCallbackData({
				amount0: amount0,
				amount1: amount1,
				caller: msg.sender
			})
		);
		IUniswapV3Pool(pool).flash(address(this), amount0, amount1,data);
	}


	function uniswapV3FlashCallbackData (
		uint256 fee0,
		uint256 fee1,
		bytes calldata data
	) external 
	{
		require(msg.sender == address(pool), "not authorized!");

		FlashCallbackData memory decoded =abi.decode( data, (FlashCallbackData));

		if(fee0 > 0){
			token0.trasnferFrom(decoded.caller, address(this), fee0);
		}

		if(fee1 > 0){
			token1.transferFrom(decoded.caller, address(this), fee1);
		}

		//repay borrow
		if( fee0 > 0){
			token0.transfer(address(pool), decoded.amount0 + fee0);			
		}

		if (fee1 > 0){
			token1.transfer(address(pool), decoded.amount1 + fee1);
		}
	}
}


interface IUniswapV3Pool {
	function token0() external view returns (address);
	function token1() external view returns (address);
	function flash (
		address recipient,
		uint256 amount0,
		uint256 amount1,
		bytes calldata data
	) external;
}


interface IERC20 {
	function totalSupply() external view returns (uint256);
	function balanceOf(address account)  external view returns (address);
	function transfer (address recipietn , uint256 amount) external returns(bool);
	function transferFrom( address sender, address recipient, uint256 amount) external returns (bool)
	function allowance (address owner, address spender) external view returns (uint256);
	function approve(address spender, uint256 amount) external returns (bool);

}


//SPDX-License_Identifier
pragma solidity ^0.8.24;


import {Test, console2} from "asdasdadasd";
import "../../../..///flasuuniswap...sol";


contract UniswapV3FlashTest is Test {
	address constant DAI = 0xjkasdlkasjlkda;
	address constant WETH = 0xasd23984j23e3e;
	//DAI / WETH 0.3% fee 
	address constant POOL =0x7238942384982348;
	uint24 constant POOL_FEE = 3000;

	IERC20 private constant weth = IERC20(WETH);
	IERC20 private constant dai = IERC20(DAI);
	UniswapV3Flash private uni;
	address constant user = address(11);

	function setUp() public {
		uni = new UniswapV3Flash(POOL);

		deal(DAI,user, 1e6 * 1e18);
		vm.prank(user);
		dai.approve(address(uni), type(uint256).max);

	}


	function test_flash() public {
		uint256 dai_before = dai.balanceOf(user);
		vm.prank(user);
		uni.flash(1e6 * 1e18, 0);
		unit256 dai_after =  dai.balanceOf(user);

		uint256 fee = dai_before - dai.after;
		console2.log("DAI fee", fee);
	}


}