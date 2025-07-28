// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {Airdrop} from "../src/Airdrop.sol";
import {FantasyToken} from "../src/ERC20.sol";

contract CallTest is Test {
    Airdrop public airdrop;
    FantasyToken public token;
    address[] receivers;

    function setUp() public {
        token = new FantasyToken{salt: "test"}("Fantasy Token", "FTK");
        token.mint(1000_000_000);
        airdrop = new Airdrop{salt: "test"}();
        receivers = [address(1), address(2), address(3)];
    }

    function testMultiTransferToken() public {
        uint256[] memory amounts = new uint256[](receivers.length);
        for (uint256 i = 0; i < receivers.length; i++) {
            amounts[i] = 1000 * (i + 1);
        }
        token.approve(address(airdrop), 1000_000_000);
        airdrop.multiTransferToken(address(token), receivers, amounts);

        for (uint256 i = 0; i < receivers.length; i++) {
            assertEq(token.balanceOf(receivers[i]), amounts[i]);
        }
    }
}
