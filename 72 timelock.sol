//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract TimeLock {
	error NotOwnerError();
	error AlreadyQueuedError(bytes32 txId);
	error TimestampNotInRangeError(uint256 blockTimestamp, uint256 timestamp);
	error NotQueuedError(bytes32 txId);
	error TimestampNotPassedError(uint256 blockTimestamp, uint256 timestamp);
	error TimestampExpiredError(uint256 blockTimestamp, uint256 expiresAt);
	error TxFailedError();

	event Queue(
		bytes32 indexed txId,
		address indexed target,
		uint256 value,
		string func,
		bytes data,
		uint256 timestamp
	);

	event Execute(
		bytes32 indexed txId,
		address indexed target,
		uint256 value,
		string func,
		bytes data,
		uint256 timestamp
	);

	event Cancel(bytes32 indexed txId);

	uint256 public constant MIN_DELAY = 10;
	uint256 public constant MAX_DELAY = 1000;
	uint256 public constant GRACE_PERIOD = 1000;

	address public owner;
	mapping(bytes32 => bool) public queued;

	constructor(){
		owner = msg.sender;
	}

	modifier onlyOwner(){
		if(msg.sender != owner){
			revert NotOwnerError();
		}
		_;
	}

	receive() external payable{}

	function getTxId(
		address _target,
		uint256 _value,
		string calldata _func,
		bytes calldata _data,
		uint256 _timestamp
	) public pure returns (bytes32)
	{
		return keccak256(abi.encode(_target, _value, _func,_data, _timestamp));
	}


	function queue(
		address _target,
		uint256 _value,
		string calldata _func,
		bytes calldata _data,
		uint256 _timestamp
	) external onlyOwner returns (bytes32 txId)
	{
		txId = getTxId(_target, _value, _func, _data, _timestamp);

		if(queued[txId]){
			revert AlreadyQueuedError(txId);
		}

		if (_timestamp < block.timestamp + MIN_DELAY || _timestamp > block.timestamp + MAX_DELAY){
			revert TimesstampNotInRangeError(block.timestamp, _timestamp)
		}

		queued[txId] = true;

		emit Queue(txId, _target, _value, _func, _data, _timestamp);
	}


	function execute (
		address _tagert,
		uint256 _value,
		string calldata _func,
		bytes calldata _data,
		uint256 _timestamp
	) external payable onlyOwner returns (bytes memory)
	{
		bytes32 txId = getTxId(_target,_value,_func,_data,_timestamp);

		if(!queued[txId]){
			revert NoQueuedError(txId);
		}

		if (block.timestamp < _timestamp){
			revert TimestampNotPassedError(block.timestamp, _timestamp);
		}

		if (block > _timestamp + GRACE_PERIOD) {
			revert TimestampExpiredError(
			block.timestamp, _timestamp + GRACE_PERIOD);
		}

		queued[txId] = false;

		bytes memory data;
		if(bytes(_func).length > 0){
			data = abi.encodePacked(bytes4(keccak256(bytes(_func))), _data);
		}else{
			data = _data;
		}

		//call target
		(bool ok, bytes memory res) = _target.call{value: _value}(data);
		if(!ok){
			revert TxFailedError();
		}

		emit Execute(txId, _target, _value, _func, _data, _timestamp);

		return res;

	}


	function cancel(bytes32 _txId) external onlyOwner {
		if(!queued[_txId]){
			revert NotQueuedError(_txId);
		}
		queued[_txId] = false;

		emit Cancel(_txId);
		
	}
}



