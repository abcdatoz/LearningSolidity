// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;


//Base contract X
contract X {
	string public name;

	constructor(string memory _name){
		name = _name	
	}

}


//Base contract Y
contract Y {
	string public text;

	constructor(string memory _text){
		text = _text;
	}
}


//there are 2 ways to initialize parect contract with parameters

//pass the parameters here in the inheritance list
contract B is X ("input to x"),Y("input to Y"){}


contract C is X,Y {
	//pass the parameters here in the constructor
	constructor(string memory _name, string memory _text) X(_name) Y(_text){

	}
}


//order of constructors called
1 x
2 y
3 D


contract D is X,Y {
	constructor() X("X was called") Y("Y was called"){}
}



//order of constructors called
1 x
2 y
3 e

contract E is X,Y {
	constructor() Y("y was called") X("x was called")
}
