// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src//Attacker.sol";
import "../src/Victim.sol";

contract AttackerTest is Test{
  Attacker attacker;
  Victim victim;
  function setUp() public {
        victim = new Victim();
        attacker = new Attacker(payable(address(victim)));
        vm.deal(address(victim), 100 ether);
        vm.deal(address(attacker), 1 ether);
    }

    function testBeginAttack() public {
        uint256 initialBalance = address(attacker).balance; // 为1eth
        assertEq(initialBalance, 1 ether, "attacker initialBalance should be 1 eth");
        vm.startPrank(address(attacker));
        attacker.beginAttack{value: 1 ether}();
        uint256 finalBalance = address(attacker).balance;
        assertGt(finalBalance, initialBalance, "reentry more then 1 eth");
        vm.stopPrank();
    }
}
