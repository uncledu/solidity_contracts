// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract LowLevelCall {
    event Log(string message, uint256 value);
    receive() external payable {}
}

contract A {
  event Log(string message, uint256 value);
  constructor() {

  }
  function a1() public {
    emit Log("a1 called", 0);
  }
  function a2() external pure returns(string memory) {
    return "a2 called";
  }
}

contract B {
  event Log(string message, uint256 value);
  constructor() {

  }
  function b1() public {
    emit Log("b1 called", 1);
  }
  function b2() external pure returns(string memory) {
    return "b2 called";
  }
}
