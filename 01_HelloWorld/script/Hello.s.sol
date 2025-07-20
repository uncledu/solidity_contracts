// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/src/Script.sol";
import {HelloWorld} from "../src/Hello.sol";

contract helloScript is Script {
    HelloWorld public hello;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        hello = new HelloWorld();

        vm.stopBroadcast();
    }
}
