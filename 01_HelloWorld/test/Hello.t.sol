// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/src/Test.sol";
import {HelloWorld} from "../src/hello.sol";

contract HelloWorldTest is Test {
    HelloWorld public hello;

    function setUp() public {
        hello = new HelloWorld();
    }

    function test_sayHello() public view {
        assertEq(hello.sayHello("fantasy"), "Hello World! I'm fantasy");
        assertEq(hello.sayHello("jojo"), "Hello World! I'm jojo");
        assertNotEq(hello.sayHello("jojo"), "Hello World! I'm jojo balabala");
    }
}
