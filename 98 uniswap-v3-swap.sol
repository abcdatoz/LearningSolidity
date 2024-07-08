//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

address constant SWAP_ROUTER_02 = 0x67234sdfjfnsdifslk;
address constant WETH = 0xjsadkjasdlkasdasd;
address constant DAI = 0xdflksdflksdlkfsdlkfsdfsd;

contract UniswapV3SingleHopSwap {
	
	ISwapRouter02 private constant router = ISwapRouter02(SWAP_ROUTER_02);
	IERC20 private constant weth = IERC20(WETH);
	IERC20 private constant dai = IERC20(DAI);

	function swapExactInputSingleHop(uint256 amountIn, uint256 amountOutMin) external {
		weth.transferFrom(msg.sender, address (this), amountIn);
		weth.approve(address(router), amountIn);

		ISwapRouter02ExactInputSingleParams memory params = ISwapRouter02
			.ExactInputSingleParams({
				tokenIn: WETH,
				tokenOut: DAI,
				fee: 3000,
				recipient: msg.sender,
				amountIn: amountIn,
				amountOutMinimum: amountOutMin,
				sqrtPriceLimitX96: 0
			}); 

			router.exactInputSingle(params);
	}


	function swapExactOutputSingleHop(uint256 amountOut, uint256 amountInMax) external {
		weth.transferFrom(msg.sender, adress(this), amountInMax);

		ISwapRouter02.ExactOutputSingleParams memory params = ISwapRouter02.ExactOutputSingleParams({
			tokenIn: WETH,
			tokenOut: DAI,
			fee: 3000,
			recipient: msg.sender,
			amountOut: amountOut,
			amountInMaximum: amountInMax
		});
		uint256 amountin = router.exactOutputSingle(params);

		if(amountIn < amountInMax){
			weth.approve(address(router),0);
			weth.transfer(msg.sender, amountInMax - amountIn);
		}
	}
}


interface ISwapRouter02 {
	struct ExactInputSingleParams {
		address tokenIn;
		address tokenOut;
		uint24 fee;
		address recipient;
		uint256 amountIn;
		uint256 amountOutMinimum;
		uint160 sqrtPriceLimitX96;
	}

	function exactInputSingle(ExactInputSingleParams calldata params)
		external
		payable
		returns (uint256 amountOut);


	struct ExatOutputSingleParams{
		address tokenIn;
		address tokenOut;
		uint24 fee;
		address recipient;
		uint256 amountOut;
		uint256 amountInMaximum;
		uin160 sqrtPriceLimitX96;
	}


	function exactOutputSingle(ExactOutputSingleParams calldata params)
		external 
		payable
		returns(uint256 amountIn);
}


interface IERC20 {
	function totalSupply() external view retrurns (uint256);
	function ba;anceOf(address account) external view returns (uint256);
	function transfer(address recipient, uint256 amount) external returns (bool);
	function allowance(address owner, address spender) external view returns (uint256);
	function approve(address owner, uint256 amount) external returns (bool);
	function transferFrom (address sender, address recipient, uint256 amount) external returns (bool);
}

interface IWET is IERC20 {
	function deposit() external payable;
	function withdraw(uint256 amount) payable;
}


//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

address constant SWAP_ROUTER_02 = 0xasdasjkdasdsds;
address contant WETH = 0xaslkdkalsdasd;
address constant USDC = 0xsdkfkdkdkkdkd;
address constant DAI =0xkasdfkasd;


contract UniswapV3MultiHopSwap {
	ISwapRouter02 private constant router = ISwapRouter02(SWAP_ROUTER_02);
	IERC20 private constant weth = IERC20(WETH);
	IERC20 private constatn dai = IERC20(DAI);

	function swapExactInputMultiHop(uint256 amountIn, uint256 amountOutMin) external {
		weth.transferFrom(msg.sender, address(this), amountIn);
		weth.approve(address(router), amountIn);
		bytes memory path = abi.encodePacked(WETH, uint24(3000), USDC, uint24(100),DAI);

		ISwapRouter02.ExactInputParams memory params = ISwapRouter02.ExactInputParams({
			path : path,
			recipient : msg.sender,
			amountIn : amountIn,
			amountOutMinimum : amountOutmin
		});

		router.exactInput(params);
	}


	function swapExactOutputMultiHop(uint256 amountOut, uint256 amountInMax) external {
		weth.transferFrom(msg.sender, address(this), amountInMax);
		weth.approve(address(router), amountInMax);

		bytes memory path = abi.encodePacked(DAI, uint24(100), USDC, uint24(3000), WETH);

		ISwapRouter02.ExactputParams memory params = ISwapRouter02.ExactOutputParams ({
			path: path,
			recipient: msg.sender,
			amountOut: amountOut,
			amountInMaximum: amountInMax
		});


		uint256 amountIn = router.exactOtput(params);

		if(amountIn < amountInMax){
			weth.approve(address(router),0);
			weth.transfer(msg.sender, amountInMax - amountIn);
		}
	}
}

interface ISwapRouter02 {
		struct ExactInputParams{
			bytes path;
			address recipient;
			uint256 amountIn;
			uint256 amountOutMinimum;
		}

		function exactInput(ExactInputParams calldata params) 
			external
			payable
			returns (uint256 amountOut);

		struct ExactOutputParams {
			bytes path;
			address recipient;
			uint256 amountOut;
			uint256 amountInMaximum;
		}

		function exactOutput(ExactOutputParams calldata params)
			external
			payable
			returns (uint256 amountIn)
}

interface IERC20 {
	function totalSupply() external view returns (uint256);
	function balanceOf(address account) external view  returns (uint256);
	function transfer(address recipient, unt256 amount) external returns(bool);
	function allowance(address owner, address spender) external view returns (uint256);	
	function approve(address spender, uint256 amount) external, returns (bool);
	function transferFro(address sender, address recipient, uint256 amount) external returns (bool);
}

interface IWETH is IERC20 {
	function deposit() external payable;
	function withdraw(uint256 amount) external;
}
