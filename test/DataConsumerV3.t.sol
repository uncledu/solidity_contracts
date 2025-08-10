// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {DataConsumerV3} from "../src/DataConsumerV3.sol";

// 在sepolia上进行测试
// forge test test/DataConsumerV3.t.sol -vvvvv --fork-url $SEPOLIA_RPC_URL
// sepolia_rpc_url 从metamask上注册账号后获取
contract DataConsumerV3Test is Test {
    DataConsumerV3 public dataConsumer;

    function setUp() public {
        dataConsumer = new DataConsumerV3();
    }

    function testGetLatestPrice() public view {
        // 获取最新价格
        int256 price = dataConsumer.getChainlinkDataFeedLatestAnswer();

        // 断言价格不为0
        assertTrue(price > 0, "Price should be greater than 0");
    }
}
