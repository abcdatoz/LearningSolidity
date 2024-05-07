//SPDX License-Identifier: MIT

pragma solidity ^0.8.24;

contract A {
	
	event Log (string message);

	function foo() public virtual {
		emit Log("A.foo called");
	}

	function bar() public virtual {
		emit  Log("a.bar called");
	}

	contract B is  A {
		function foo() public override {
			emit Log("B.foo called");
		}

		function bar() public override {
			emit Log("b.bar called");
		}

	}

	contract C i A {
		function foo() public virtual override {
			emit Log("C.foo called");
			A.foo();
		}

		function bar() public virtual override {
			emit Log("C.bar called")
			super.bar();

		}
	}


	contract D is B,C {
		function foo() public override (B,C) {
			super.foo();
		}

		function bar public override (B, C) {
			super.bar
		}
	}

}