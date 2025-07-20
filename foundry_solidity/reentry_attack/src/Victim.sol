// SPDX-License-Identifier: MIT

// This contract is vulnerable. Do not use in production!
// This contract is vulnerable. Do not use in production!
// This contract is vulnerable. Do not use in production!

pragma solidity ^0.8.0;


contract Victim {
  mapping(address => uint256) public balances;

  function deposit() external payable {
    require(msg.value >= 1 ether, "cant deposit less than 1 ether");
    balances[msg.sender] += msg.value;
  }

  function withdraw() external {
    uint256 amount = balances[msg.sender];
    require(amount > 0, "must have a balance more then 0 to withdraw");
    
    (bool success, ) = msg.sender.call{value:amount}("");
    require(success, "withdraw need success");
    balances[msg.sender] = 0;
  }

  function totalBalance() public view returns(uint) {
    return address(this).balance;
  } 
}
