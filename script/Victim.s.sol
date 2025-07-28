// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Victim} from "../src/Victim.sol";
import {Attacker} from "../src/Attacker.sol";

contract VictimScript is Script {
  Victim internal victim;

  Attacker internal attacker;

  function run() public{
    vm.startBroadcast();
    victim = new Victim{salt: "victim"}();
    attacker = new Attacker{salt:"attacker"}(payable(address(victim)));
    vm.deal(address(victim), 10 ether);
    vm.deal(address(attacker), 2 ether);
    vm.stopBroadcast();
    vm.startPrank(address(attacker));
    attacker.beginAttack{value: 1 ether}();
    vm.stopPrank();
    require(address(attacker).balance > 2 ether, "should be 11 ether after attack");
    // console.log(address(attacker).balance);
  }
}
