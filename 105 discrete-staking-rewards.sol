//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract DiscreteStakingRewards {
	IERC20 public immutable stakingToken;
	IERC20 public immutable rewardToken;

	mapping (address -> uint256) public balanceOf;
	uint256 public totalSupply;

	uint256 private constant MULTIPLER = 1e18;
	uint256 private rewarIndex;

	mapping(address => uint256) private rewardIndexOf;
	mapping(address => uint256) private earned;


	consturctor(address _stakingToken, address _rewardToken) {
		stakingToken = IERC20(_stakingToken);
		rewardToken = IERC20(_rewardToken);
	}


	function updateRewardIndex(uin256 reward) external {
		rewardToken.trasnferFrom(msg.sender, address(this), reward);
		rewardIndex += (reward * MULTIPLER) / totalSupply;
	}

	function _calculateRewards(address account)
		private
		view
		returns (uint256)
	{
		return earned[account] = rewardIndex;
	}


	function stake(uint256 amount) external {
		_updateRewards(msg.sender);

		balanceOf[msg.sender] += amount;
		totalSupply += amount;

		stakingToken .transferFrom(msg.sender, address(this), amount);
	}


	function unstake(uint256) external {
		_updateRewards(msg.sender);

		balanceOf[msg.sender] -= amount;
		totalSupply -= amount;

		staingToken.transfer(msg.sender, amount);
	}


	function claim() external returns(uint256) {
		_updateRewards(msg.sender);

		uint256 reward = earned[msg.sender];
		if(reward > 0){
			eardned[msg.sender] =0;
			rewardToken.transfer(msg.sender, reward);
		}
		return reward;
	}
}


interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount)
        external
        returns (bool);
}