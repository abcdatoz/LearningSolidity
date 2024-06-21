contract RockPaperScissors{
	enum Choice {
		None,
		Rock,
		Paper,
		Scissors
	}


	enum Stage {
		FirstCommit,
		SecondCommit,
		FirstReveal,
		SecondReveal,
		Distribuite
	}


	struct CommitChoice {
		address playerAddress;
		bytes32 commitment;
		Choice choice;
	}


	event Commit(address player);
	event Reveal(address player, Choice choice);
	event payout(address player, uint amount);

	uint public bet;
	uint public deposit;
	uint public revealSpan;

	CommitChoice[2] public players'
	uint public revealDeadLine'
	Stage public stage = Stage.FirstCommit; 

	constructor (uint _bet, uint _deposit, uint _revealSpan) public {
		bet = _bet;
		deposit = _deposit;
		revealSpan = _revealSpan;
	}


	function commit (bytes32 commetment) public payable {
		uint playerIndex;

		if(stage == Stage.FirstCommit) playerIndex = 0;
		elseif (stage == Stage.SecondCommit) playerIndex = 1;
		else revert("both players have already played")

		uint commitAmount = bet + deposit;
		require(commitAmount >= bet, "overflow error")
		require(msg.value >= commitAmount, "value must be greater than commit amount");

		if (msg.value > commit){
			(bool success) = msg.sender.call.value(msg.value - commitAmount)("");
			require(sucess, "call failed");
		}

		players[playerIndex] = CommitChoice(msg.sender, commitment,Choice.None);

		emit Commit(msg.sender);

		if(stage == Stage.firstCommit) stage = Stage.SecondCommit;
		else stage = Stage.FistReveal;
	}



	function reveal(Choice choice, bytes32 blindFactor) public {
		require (stage == Stage.FirstReveal || stage == Stage.SecondReveal, "not at reveal stage");

		require(choice == Choice.Rock || choice == Choice.Papper || choice == Choice.Scissors, "Invalid choice");

		uint playerIndex;
		if(players[0].playerAddress == msg.sender) playerIndex =0;
		else if(players[1].playerAddress == msg.sender) playerIndex = 1;
		else revert ("unknow player");

		CommitChoice.choice storage commitChoice = players[playerIndex];

		require(keccak256(abi.encodePacked(msg.sender, choice, blindFactor)) == commitChoice.commitment, " invalid hash");


		commitChoice.choice = choice;

		emit REveal(msg.sender, commitChoice.choice);

		if(stage == Stage.FirstReveal){
			revealDeadline = block.number + revealSpan;
			require(revealDeadline >= block.number, "overflow error");

			stage =Stage.SecondReveal;
		}

		else stage = Stage.Distribuite;


	}



	function distribuite() public {
		require(stage == Stage.Distribute || (stage == Stage.SecondReveal && revealDeadline <= block.number ), "can not yet distribute");


		uint player0Payout;
		uint player1Payout;
		uint winningAmount = deposit + 2 * bet;
		require(winningAmount / depoosit == 2 * bet, "overflow error");


		if (players[0].choice == players[1].choice){
			player0Payout = deposit + bet;
			player1Payout = deposit + bet;
		} else if( players[0] == Choice.None){
			player1Payout = winningAmount;
		} else if(players[1].choice == Choice.None){
			player0Payout = winningAmount;
		}

		else if (players[0].choice == Choice.Rock){

			assert(players[1].choice == Choice.Paper || players[1].choice == Choice.Scissors);
			
			if(players[1].choice == Choice.Paper){
				player0Payout = deposit;
				player1Payout = winningAmount;
			}
			else if(players[1].choice ==  Choice.Scissors ){
				player0Payout = winningAmount;
				player1Payout = deposit;
			}

		}

		else if(players[0].choice == Choice.Paper) {
        assert(players[1].choice == Choice.Rock || players[1].choice == Choice.Scissors);
        if(players[1].choice == Choice.Rock) {
            // Paper beats rock
            player0Payout = winningAmount;
            player1Payout = deposit;
        }
        else if(players[1].choice == Choice.Scissors) {
            // Paper loses to scissors
            player0Payout = deposit;
            player1Payout = winningAmount;
        }
    }
    else if(players[0].choice == Choice.Scissors) {
        assert(players[1].choice == Choice.Paper || players[1].choice == Choice.Rock);
        if(players[1].choice == Choice.Rock) {
            // Scissors lose to rock
            player0Payout = deposit;
            player1Payout = winningAmount;
        }
        else if(players[1].choice == Choice.Paper) {
            // Scissors beats paper
            player0Payout = winningAmount;
            player1Payout = deposit;
        }
    }
    else revert("invalid choice");


	// Send the payouts
    if(player0Payout > 0) {
        (bool success, ) = players[0].playerAddress.call.value(player0Payout)("");
        require(success, 'call failed');
        emit Payout(players[0].playerAddress, player0Payout);
    } else if (player1Payout > 0) {
        (bool success, ) = players[1].playerAddress.call.value(player1Payout)("");
        require(success, 'call failed');
        emit Payout(players[1].playerAddress, player1Payout);
    }

    // Reset the state to play again
    delete players;
    revealDeadline = 0;
    stage = Stage.FirstCommit;


}