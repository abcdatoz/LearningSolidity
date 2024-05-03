//SPDX-License-Identifier:MIT

pragma solidity ^0.8.24;


contract Event {
	//event declaration
	//up to 3 parameters can be indexed
	//indexed parameters helps you filter the logs by the indexed paramater


	event Log(address indexed sender, string message);

	event AnotherLog();

	funtion test() public {
		emit Log (msg.sender, "Hello world");
		emit Log(msg.sender, "hey dey");
		emit AnotherLog();
	}
}