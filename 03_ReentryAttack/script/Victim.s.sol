// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Victim} from "../src/Victim.sol";
import {Attacker} from "../src/Attacker.sol";

contract VictimScript is Script {
  Victim public victim;

  Attacker public attacker;

  function setUp() public {
    vm.startBroadcast();
    victim = new Victim();
    attacker = new Attacker(payable(address(victim)));
    vm.deal(address(victim), 10 ether);
    vm.deal(address(attacker), 2 ether);
    console.logUint(address(victim).balance);
    console.logUint(address(attacker).balance);
    vm.stopBroadcast();
  }
  function run() public{
    vm.startPrank(address(attacker));
    attacker.beginAttack{value: 1 ether}();
    vm.stopPrank();
    require(address(attacker).balance > 2 ether, "should be 11 ether after attack");
    console.log(address(attacker).balance);
  }
}
