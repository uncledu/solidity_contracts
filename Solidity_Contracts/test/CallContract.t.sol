// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/CallContract.sol";


contract CallContractTest is Test {
    ContractA public contractA;
    CallContract public callContract;

    function setUp() public {
        contractA = new ContractA();
        callContract = new CallContract();
    }

    // 测试通过 CallContract 调用 ContractA 的 setA 函数
    function testCallSetA() public {
        uint a = 100;
        callContract.callSetA{value: 1 ether}(payable(address(contractA)), a);
        assertEq(contractA.getA(), a);
        // assertEq(contractA.getBalance(), 1 ether);
    }

    // 测试通过 CallContract 调用 ContractA 的 getA 函数
    function testCallGetA() public {
        uint a = 100;
        contractA.setA(a);
        uint result = callContract.callGetA(contractA);
        assertEq(result, a);
    }

    // 测试通过 CallContract 调用 ContractA 的 getA 函数（使用地址）
    function testCallGetA2() public {
        uint a = 100;
        contractA.setA(a);
        uint result = callContract.callSetA2(payable(address(contractA)));
        assertEq(result, a);
    }

    // 测试通过 CallContract 向 ContractA 转账 ETH
    function testSetTransferETH() public {
        uint256 value = 1 ether;
        callContract.setTransferETH{value: value}(payable(address(contractA)), 0);
        assertEq(contractA.getBalance(), value);
        assertEq(contractA.getA(), 0);
    }
}
