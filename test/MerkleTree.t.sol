// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {MerkleTree} from "../src/MerkleProof.sol";

contract MerkleProofTest is Test {
    // [
    // "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
    // "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2",
    // "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db",
    // "0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB"
    // ]
    // merkle树
    // [
    //   [
    //     "0x5931b4ed56ace4c46b68524cb5bcbf4195f1bbaacbe5228fbd090546c88dd229",
    //     "0x999bf57501565dbd2fdcea36efa2b9aef8340a8901e3459f4a4c926275d36cdb",
    //     "0x04a10bfd00977f54cc3450c9b25c9b3a502a089eba0097ba35fc33c4ea5fcb54",
    //     "0xdfbe3e504ac4e35541bebad4d0e7574668e16fefa26cd4172f93e18b59ce9486"
    //   ],
    //   [
    //     "0x9d997719c0a5b5f6db9b8ac69a988be57cf324cb9fffd51dc2c37544bb520d65",
    //     "0x4726e4102af77216b09ccd94f40daa10531c87c4d60bba7f3b3faf5ff9f19b3c"
    //   ],
    //   [
    //     "0xeeefd63003e0e702cb41cd0043015a6e26ddb38073cc6ffeb0ba3e808ba8c097"
    //   ]
    // ]
    MerkleTree public merkleTree;

    function setUp() public {
        merkleTree =
            new MerkleTree("FantasyNFT", "FNFT", 0xeeefd63003e0e702cb41cd0043015a6e26ddb38073cc6ffeb0ba3e808ba8c097);
    }

    function test() public {
        address account = address(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);
        uint256 tokenId = 0;
        bytes32[] memory proof = new bytes32[](2);
        proof[0] = 0x999bf57501565dbd2fdcea36efa2b9aef8340a8901e3459f4a4c926275d36cdb;
        proof[1] = 0x4726e4102af77216b09ccd94f40daa10531c87c4d60bba7f3b3faf5ff9f19b3c;

        // 可以成功mint
        vm.prank(account);
        merkleTree.mint(account, tokenId, proof);
        // 可以看到: emit Transfer(from: 0x0000000000000000000000000000000000000000, to: 0x5B38Da6a701c568545
        // dCfcB03FcB875f56beddC4, tokenId: 0)

        // revert报错kkk
        vm.expectRevert("Already minted");
        merkleTree.mint(account, tokenId, proof);
    }
}
