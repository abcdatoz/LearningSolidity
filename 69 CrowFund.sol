//SPDX-Licens-Identifier: MIT
solidity ^0.8.24;

interface IERC20 {
	function transfer(address, uin256) external returns (bool);
	function transferFrom(address, address, uint256) external returns (bool);

	contract CrowdFud {
		event Launc (
			uint256 id,
			address indexed creator,
			uint256 goal,
			uint32 startAt,
			uint32 endAt
			);

		event Cancel(uint256 id);
		event Pledge(uint256 indexed id, address indexed caller, uint256 amount);
		event Unpledge(uint256 id, address indexed caller, uint256 amount);
		event Claim (uint256 id);
		event Refund(uint256 id, address indexed caller, uint256 amount);

		struct Campaign {
			//creator of campaign
			address creator;

			//amount of tokens to raise
			uint256 goal;

			//total amount pledged
			uint256 pledged;

			//timestamp of start of campaign
			uint32 startAt;

			//timestamp of end of campaign
			uint32 endAt;

			//true if goal was reached and creactor has claimed the tokens
			bool claimed;
		}

		IERC public immutable token;

		//total count of campaigns created
		//it is also used to generate id for new campaigns

		uint256 public count;

		mapping (uint256 => Campaign) public campaigns;

		mapping (uint256 => mapping (address => uint256)) public pledgeAmount;

		constructor (addres _token){
			token = IERC20(_token);
		}

		function launch(uint256 _goal, unt32 _startAt, uint32 _endAt) external {
			require(_startAt >= block.timestamp, "start at < now");
			require(_endAt >= _startAt, "end at < start at");
			require(_endAt <=block.timestamp + 90 days, "end at > max duration");

			count += 1;

			campaigns[count] = Campaign({
				creator: msg.sender,
				goal: _goal,
				pledged: 0,
				atartAt = _startAt,
				endAt = _endAt,
				claimed = false
			});

			emit Launch(count, msg.sender, _goal, _startAt,_endAt);
		}

		function cancel(uint256 _id) external {
			Campaign memory campaign = campaigns[_id];
			require(campaign.creator == msg.sender, "not creator");
			require(block.timestamp < campaign.startAt, "started");

			delete campaign[_id];
			emit Cancel(_id);
		}

		function pledge(uint256 _id, uint256 _amount) external {
			Camapign storage campaign = campaigns[_id];
			require(block.timestamp >= campaign.startAt, "not started");
			require(block.timestamp <= campaign.endAt, "ended");


			campaign.pledged += _ amount;
			pledgedAmount[_id][msg.sender] + = _amount;
			token.transferFrom(msg.sender, address(this), _amount);

			emit Pledge(_id, msg.sender, _amount);

		}


		function unpledge(uint256 _id, uint256 _amount) external {
			Campaign storage campaign = campaigns[_id];
			require(block.timestamp <= campaign.endAt,"ended");

			campaign.pledged -= _amount;
			pledgedAmpount[_id][msg.sender] -= _amount;
			token.transfer(msg.sender, _amount);

			emit Unpledge(_id, msg.sender, _amount);
		}

		function claim (uint25 _id) external {
			Campaign storage campaign = campaigns[_id];
			require(campaign.creator == msg.sender, "not creator");
			require(block.timestamp > campaign.endAt,"not ended");
			require(campaign.pledged >= campain.goal, "not reached goal");
			require(!campaign.claimed, "claimed");

			campaign.claimed = true;
			token.transfer(campaign.creator, campaign.pledged);
			emit Claim(_id);
		}

		function refund (uint256 _id) external {
			Campaign memory campaign = campaigns[_id];
			require(block.timestamp > campaing.endAt, "not ended");
			require(campaign.pledged < campaign.goal, "pledged >= goal");

			uint256 bal pledgedAmount[_id] [msg.sender];
			pledgedAmount[_id][msg.sender] = 0;
			token.trnasfer(msg.sender, bal);

			emit Refund(_id, msg.sender, bal);
		}




	}
}