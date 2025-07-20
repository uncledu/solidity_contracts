// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract HelloWorld {
    string public s = "Hello World! I'm ";

    function sayHello(string memory name) public view returns (string memory) {
        return string.concat(s, name);
    }
}
