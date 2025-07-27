// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import {Context} from "@openzeppelin/utils/Context.sol";

contract FantasyToken is Context, IERC20 {
    mapping(address => uint256) public override balanceOf;

    mapping(address => mapping(address => uint256)) public override allowance;

    address public owner;

    uint256 public override totalSupply;

    string public name;

    string public symbol;

    uint8 public decimals = 18; // 小数位数

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        owner = msg.sender;
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        address sender = msg.sender;
        require(balanceOf[sender] >= amount, "Insufficient balance");
        balanceOf[sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        require(msg.sender != address(0), "invalid owner address");
        require(spender != address(0), "invalid spender address");
        require(owner != spender, "Cannot approve self");
        allowance[owner][spender] = amount;
        emit Approval(owner, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public override returns (bool) {
        address spender = msg.sender;
        if (allowance[from][spender] < value) {
            revert("Insufficient allowance");
        }
        if (balanceOf[from] < value) {
            revert("Insufficient balance");
        }
        balanceOf[from] -= value;
        balanceOf[to] += value;
        return true;
    }

    function mint(uint256 amount) external {
        require(msg.sender == owner, "Only owner can mint tokens");
        totalSupply += amount;
        balanceOf[_msgSender()] += amount;
        emit Transfer(address(0), _msgSender(), amount);
    }
}
