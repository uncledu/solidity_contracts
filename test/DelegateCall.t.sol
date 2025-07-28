// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/DelegateCall.sol";


contract DelegateCallTest is Test {
    C c; 
    B b;
    function setUp() public {
      c = new C();
      b = new B();
      vm.deal(address(c), 10 ether); // 给 ContractA 10 ether
      vm.deal(address(b), 10 ether); // 给 ContractA 10 ether
    }
    
    function testCallSetN() public {
      uint a = 100;
      (bool success, bytes memory data) = b.callSetN(address(c), a);
      assertTrue(success);
      assertEq(data, bytes(""));
      uint cN = c.getN();
      assertEq(cN, a);
      uint bN = b.getN();
      assertEq(bN, 0, "B's state variable should not be affected by call");
    }
    
    function testDelegateCallSetN() public {
      uint a = 100;
      (bool success, bytes memory data) = b.delegatecallSetN(address(c), a);
      assertTrue(success, "should call delegatecallSetN successfully");
      if (data.length > 0){
        uint bN = abi.decode(data, (uint256));
        assertEq(bN, a, "bN should be equal a");
      }
      uint cN = c.getN(); // staticcall
      assertEq(cN, 0, "C's state variable should not be affected by delegatecall");
      uint bNAfter = b.getN(); // staticcall
      assertEq(bNAfter, a, "B's state variable should be updated by delegatecall");
    }
}
