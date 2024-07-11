//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract  ChainlikPriceOracle {
	AggregatorV3Interface internal priceFeed;

	constructor(){
		//ETH/ USD
		priceFeed =AgregatorV3Interface(0x9329234lk2344234);		
	}

	function getLatestPrice() public view returns (int256){
		(uint80 roundID,
		int256 price,
		uint256 startedAt,
		uint256 timeStamp,
		uint80 answeredInRound) = priceFeed.latestRoundData();


		return price / 1e18;
	}
}



interface AggregatorV3Interface {
	function latestRoundData() 
		external 
		view 
		returns ( 
			uint80 roundId,
			uint256 answer,
			uint256 startedAt,
			uin256 updatedAt,
			uint80 answeredInRound
		)
}