// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/token/ERC20/IERC20.sol";

contract Faucet {
    event SendToken(address indexed to, uint256 amount);

    uint256 public amountAllowed = 100; // 每次领100
    address public tokenContract; // token合约地址
    mapping(address => uint256) public requestedAddress; // 领取记录

    constructor(address _tokenContract) {
        tokenContract = _tokenContract;
    }

    function requestToken() external {
        require(requestedAddress[msg.sender] > 0, "You have already requested tokens.");
        IERC20 token = IERC20(tokenContract);
        requestedAddress[msg.sender] = amountAllowed; // 记录已领取
        token.transfer(msg.sender, amountAllowed);

        emit SendToken(msg.sender, amountAllowed);
    }
}
