// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";

contract FantasyToken is IERC20{
  mapping(address => uint) public override balanceOf;

  mapping(address => mapping(address => uint)) public override allowance;

  uint public override totalSupply;

  string public name;

  string public symbol;

  uint8 public decimals = 18; // 小数位数

  constructor(string memory _name, string memory _symbol) {
    name = _name;
    symbol = _symbol;
  }

  function transfer(address to, uint amount) public returns(bool) {
    address sender = msg.sender;
    require(balanceOf[sender] >= amount, "Insufficient balance");
    balanceOf[sender] -= amount;
    balanceOf[to] += amount;
    emit Transfer(sender, to, amount);
    return true;
  }

  function allowance(address owner, address spender) external view override returns (uint256) {
    require(owner != address(0), "invalid owner address");
    require(spender != address(0), "invalid spender address");
    require(owner != spender, "Cannot approve self");
    return allowance[owner][spender];
  }

  function approve(address spender, uint amount) external override returns(bool) {
    address owner = msg.sender;
    require(owner != address(0), "invalid owner address");
    require(spender != address(0), "invalid spender address");
    require(owner != spender, "Cannot approve self");
    allowance[owner][spender] = amount;
    // emit Approval(owner, spender, value);(owner, spender);  
  }

  function transferFrom(address from, address to, uint256 value) public override returns (bool) {
    address spender = msg.sender;
    if allowance[from][spender] < value {
      revert("Insufficient allowance");
    }
    if balanceOf[from] < value {
      revert("Insufficient balance");
    }
    balanceOf[from] -= value;
    balanceOf[to] += value;
  }
}
