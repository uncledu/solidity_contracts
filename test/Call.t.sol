// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Call.sol";


contract CallTest is Test {
    ContractA public contractA;
    Call public callContract;

    function setUp() public {
        contractA = new ContractA();
        callContract = new Call();
        vm.deal(address(contractA), 10 ether); // 给 ContractA 10 ether
        vm.deal(address(callContract), 10 ether); // 给 ContractA 10 ether
    }

    // 测试通过 Call 调用 ContractA 的 setA 函数
    function testCallSetA() public {
        uint a = 100;
        uint256 x = 10;
        callContract.callSetA{value: 0.1 ether}(payable(address(contractA)), a);
    }

    function testCallGetA() public {
        uint a = 100;
        contractA.setA{value: 0.1 ether}(a);
        uint result = callContract.callGetA(payable(address(contractA)));
        assertEq(result, a, "callGetA should return the correct value");
    }
   
    function testCallNonExistentFunction() public {
        (bool success, bytes memory data) = address(callContract).call(
            abi.encodeWithSignature("callNonExistentFunction(address)", address(contractA))
        );
        assertFalse(success, "Calling a non-existent function should fail");
        assertEq(data, bytes(""), "Data returned should be empty");
    }
}
