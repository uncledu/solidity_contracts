// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {SignatureNFT, ECDSA} from "../src/Signature.sol";

contract SignatureTest is Test {
    // SignatureNFT public nft;
    address public signer;
    bytes32 signedMsg;
    bytes signature;

    function setUp() public {
        // Hello
        bytes32 _msg = keccak256(abi.encodePacked("Hello"));
        signedMsg = ECDSA.toEthSignedMessageHash(_msg);
        // ethdev账号
        signer = 0xfabc9a8e1C9A0182CcC0d8FBF5248220b4F36952;
        // cast wallet sign $(cast k Hello) --account ethdev 生成的签名
        signature =
            hex"94349e97ec531122b7d55dfc14074eac1cf8ef477f2c7cfb53e676db98ba201b4d1fdd1f8dcaf6906ff2ddcd3faf4f1957993897c715127db41ad9c74c12eb711c";
    }

    function testValidateSignature() public view {
        assertTrue(ECDSA.verify(signedMsg, signature, signer));
    }
}
