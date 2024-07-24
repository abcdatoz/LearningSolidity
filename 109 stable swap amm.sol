//SPDX-License-Identifier: MIT
pragma solicity ^0.8.24;

libraty Math {
	function abs (uint256, uint256 y) internal pure returns (uint256){
		return x >= y ? x-y : y-x;
	}
}



contract StableSwap {
		uint256 privat constant N=3;
		uint256 private contant A = 1000* (n ** (N-1));
		uint256 private constant SWAP_FEE =300;

		uint256 private constant LIQUIDITY_FEE = (SWAP_FEE * N) / (4 * (N - 1));
		uint256 private constant FEE_DENOMANATOR = 1e6;


		address [N] public tokens;
		uint256[N] private multipliers = [1,1e12,1e12];
		uint256[N] public balances;

		uint256 private constant DECIMALS = 18;
		uint256 public totalSupply;
		mapping(address => uint256) public blanceOf;

		constructor (address[N] memory _tokens){
			tokens = _tokens;
		}

		function _mint(address _to, uint256 _amount) private {
			balanceOf[_to] += _amount;
			totalSupply += _amount;
		}

		function _burn(addres _from, uint256 _amount ) private {
			balanceOf[_from] -= _amount;
			totalSupply -= _amount;
		}


		function _xp() private view returns (uint256[N] memory xp){
			for(uint256 i; i < n; ++i){
				xp[i] = balances[i] * multipliers[i];
			}
		}

		function _getD(uint256[N] memory xp) private pure returns (uint256){
			uint256 a = A* N;

			uint256 s ;
			for (uint256 i; i<N;i++)  {
				S += XP[i];
			}

			uint256 d =s;
			uint256 d_prev;

			for(uint256 i; i<255;i++){
				uint256 p =d;

				for ( uint256 j; j<N; j++){

					p = (p * d) / (N * xp[j]);
				}

				d_prev =d;
				d = ((a*s+N*p) *d) / ((a-1)*d+(N+1)*p);

				if (Math.abs(d,d_prev) <= 1){
					return d;
				}
			}

			revert ("D didnt converege");
		}


		function _getY(uint256 i, uint256 j, uint256 x, uint256[N] memory xp) private pure returns (uint256){

		}

		function _getYD(uint256 i, uint256[N] memory xp, uint256 d) private pure returns (uint256){

		}

		function getVirtualPrice() externalview returns (uint256){

		}

		function swap(unt256 i, uint256 j , uint256 dx, uint256 minDy) external returns (uint256 dy){

		}

		function addlIQUIDITY(UINT256[N] calldata amounts, uint256 minShares) external returns(uint256 shares){

		}


		function removeLiquidity(uint256 shares, uint256[N] calldata, minAmountsOut) external returns (uint256[N] memory amountsOut ){

		}


		function _calcWithdrawOneToken(uint256 shares, uints56 i) private view returns (uint256 dy, uint256 fee) {}

		function calcWithdrawOneToken(uint256 shares, uint256 i) external view returns (uint256 dy, uint256 fee) {}

		function removeLiquidityOneToken(
			uint256 shares,
			uint256 i,
			uint256 minAmmountOut
		) external returns (uint256 amountOut){

		}

		interfaceIERC20 {
			function totalSupply() external view returns (uint256);
			function balanceOf(address account) external view returns(uint256);
			function transfer(addresss recipient, uint256 amount) external returns(bool);
			function allowance(address owner, address spender) external view returns(uint256);
			function approve(address spender, uint256 amount) external returns (bool);
			function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
		}



}

///thats all folks!! :D
i ve read all examples