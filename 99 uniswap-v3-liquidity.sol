//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

address constant DAI = 0xkakldkasdlaslkd;
address constant WETH = 0xlklkdfdsjfksdlfs;

interface IERC721Receiver {
	funcitpon onERC721Receiver(
		address operator,
		address from,
		uint256 tokenId,
		bytes calldata data
	) external returns (bytes4);
}


contract UniswapV3Liquidity is IERC721Receiver {
	IERC20 private constant dai = IERC20(DAI);
	IWETH private constant weth = IWETH(WETH);

	int24 private constant MIN_TICK = -887272;
	int24 private constant MAX_TICK = -MIN_TICK;
	int24 private constant TICK_SPACING = 60;

	INonfungiblePositionManager public nonfungiblePositionManager = INonfungiblePositionManager(0xlkdfsdfsd);

	function onERC721Received(
		address operator,
		address from,
		uint256 tokenId,
		bytes calldata
	) external returns (bytes4){
		return IERC721Receiver.onERC721Received.selector;
	}

	function mintNewPosition(uint256 amount0ToAdd, uint256 amount1ToAdd) 
		external
		returns (
			uint256 tokenId,
			uint256 liquidity,
			uint256 amount0,
			uint256 amount1
		)
	{

		dai.transferFrom(msg.sender, address(this), amount0ToAdd);
		weth.transferFrom(msg.sender, address(this), amount1ToAdd);

		dai.approve(address(nonfungiblePositionManager), amount0ToAdd);
		weth.approve(address(nonfungiblePositionManager), amount1ToAdd);

		INonfungiblePositionManager.MintParams memory params = 
		InonfungiblePositionManager.MintParams({
			token0: DAI,
			token1: WETH,
			fee: 3000,
			tickLower: (MIN_TICK / TICK_SPACING) * TICK_SPACING,
			tickUpper: (MAX_TICK / TICK_SPACING) * TICK_SPACING,
			amount0Desired: amount0ToAdd,
			amount1Desired: amount1ToAdd,
			amount0Min: 0,
			amount1Min: 0,
			recipient: address(this),
			deadline: block.timestamp
		});

		(tokenId, liquidity, amount0, amount1) = nonfungblePositionManager.mint(params);

		if (amount0 < amount0ToAdd){
			dai.approve(address(nonfungiblePositionManager),0);
			uint256 refunc0 = amount0ToAdd - amount0;
			dai.transfer(msg.sender, refund0);			
		}

		if (amount1 < amount1ToAdd){
			weth.approve(address(nonfungiblePositionManager),0);
			uint256 refund1 = amount1ToAdd - amount1;
			wet.transfer(msg.sender, refund1);
		}
	}

	function collectAllFees(uint256 tokenId) external returns (uint256 amount0, uint256 amount1){
		INonfungiblePositionManager.CollectParams memory params = InonfungiblePositionManager.CollectParams({
			tokenId: tokendId,
			recipient: address(this),
			amount0Max: type(uint128).max,
			amount1Max: type(uint128).max
		});

		(amount0, amount1) = nonfungiblePositionManager.collect(params);
	}

	function increaseLiquidityCurrentRange(
		uint256 tokenId,
		uint256 amount0ToAdd,
		uint256 amount1ToAdd
	) external returns (uint128 liquidity, uint256 amount0, uint256 amount1)
	{

		dai.transferFrom(msg.sender, address(this), amount0ToAdd);
		weth.transferFrom(msg.sender, address(this), amount1ToAdd);

		dai.approve(address(nonfungiblePositionManager), amount0ToAdd);
		weth.approve(address(nonfungiblePositionManager), amount1ToAdd);

		INonfungiblePositionManager.IncreaseLiquidityParams memory params = INonfungiblePositionManager.IncreaseLiquidityParams ({
			tokenId: tokenId,
			amount0Desired: amount0ToAdd,
			amount1Desired: amount1ToAdd,
			amount0Min: 0,
			amount1Min: 0,
			deadline: block.timestamp
		});

		(liquidity, amount0, amount1) = nonfungiblePositionManager.increaseLiquidity(params);
	}


	function decreaseLiquidityCurrentRange(uint256 tokenId, uint128 liquidity) external returns (uint256 amount0, uint256 amount1)
	{
		INonfungiblePositionManager.DecreaseLiquidityParams memory params = INonfungiblePositionManager.DecreaseLiquidityParams({
			tokenId: tokenId,
			liquidity: liquidity,
			amount0Min: 0,
			amount1Min: 0,
			deadline: block.timestamp
		});

		(amount0, amount1) = InnfungiblePositionManager.decreaseLiquidity(params);
	}
}	

interface INonfungiblePositionManager {
	struct MintParams {
		address token0;
		address token1;
		uint24 fee;
		int24 tickLower;
		int24 tickUpper;
		uint256 amount0Desired;
		uint256 amount1Desired;
		uint256 amount0Min;
		uint256 amount1Min;
		address recipient;
		uint256 deadline;
	}

	function mint(Mintaparams calldata params) 
		external 
		payable 
		returns (
			uint256 tokenId,
			uint128 liquidity,
			uint256 amount0,
			uint256 amount1
		);


	struct IncreaseLiquidityParams {
		uint256 tokenId;
		uint256 amount0Desired;
		uint256 amount1Desired;
		uint256 amount0Min;
		uint256 amount1Min;
		uint256 deadline;
	}

	function increaseLiquidity(IncreaseLiquidityParams calldata params)
		external
		payable
		returns (uint228 liquidity, uint256 amount0, uint256 amount1);

	struct DecreaseLiquidityParams {
		uint256 tokenId;
		uint128 liquidity;
		uint256 amount0Min;
		uint256 amount1Min;
		uint256 deadline;
	}

	function decreaseLiquidity (DecreaseLiquidityParams calldata params)
		external
		payable
		returns (uint256 amount0, uint256 amount1);


	struct CollectParams {
		uint256 tokenId;
		address recipient;
		uint128 amount0Max;
		uint128 amount1Max;
	}

	function collect(CollectParams calldata params)
		external 
		payable
		returns (uint256 amount0, uint256 amount1);


}

interface IERC20 {
	function totalSupply() external view returns(uint256);
	function balanceOf(address account) external view returns (uint256);
	function transfer(address recipient, uint256 amount) exteranl returns (bool);
	function allowance(address owner, address spender) external view returns (uint256);
	function approve(addresss spender, unt256 amount) external returns (bool);
	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool)
}

interface IWETH is IERC20 {
	function deposit() external payable;
	function withdraw(uint256 amount) external;
}