// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Create2.sol";


contract Create2Test is Test {

    function setUp() public {
    }

    function testCreatePair() public {
        PairFactory2 factory = new PairFactory2();
        address tokenA = address(0x123);
        address tokenB = address(0x456);
        uint arg = 42;

        // 计算预期地址
        address expectedAddress = factory.calculateAddr(tokenA, tokenB, arg);
        
        // 创建Pair合约
        address pairAddress = factory.createPair2(tokenA, tokenB, arg);
        
        // 验证创建的地址是否与预期一致
        assertEq(pairAddress, expectedAddress, "Created pair address does not match expected address");
        
        // 验证Pair合约的初始化状态
        Pair pair = Pair(pairAddress);
        assertEq(pair.token0(), tokenA, "Token0 address mismatch");
        assertEq(pair.token1(), tokenB, "Token1 address mismatch");
    }

}
