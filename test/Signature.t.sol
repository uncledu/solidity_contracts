// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {SignatureNFT, ECDSA, WhiteUser} from "../src/Signature.sol";

contract SignatureTest is Test {
    SignatureNFT public nft;
    address public signer;
    bytes32 signedMsg;
    bytes signature;
    WhiteUser[3] whitelist;

    function setUp() public {
        // Hello
        bytes32 _msg = keccak256(abi.encodePacked("Hello"));
        signedMsg = ECDSA.toEthSignedMessageHash(_msg);
        // ethdev账号
        signer = 0xfabc9a8e1C9A0182CcC0d8FBF5248220b4F36952;

        // cast wallet sign $(cast k Hello) --account ethdev 生成的签名
        signature =
            hex"94349e97ec531122b7d55dfc14074eac1cf8ef477f2c7cfb53e676db98ba201b4d1fdd1f8dcaf6906ff2ddcd3faf4f1957993897c715127db41ad9c74c12eb711c";

        // nft白名单模式
        nft = new SignatureNFT("SignatureNFT", "SNFT", signer);

        // 先生成对硬的hash
        //   ~ cast abi-encode --packed "(address, uint256)" 0x0000000000000000000000000000000000000001 0
        // 0x00000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000
        // ➜  ~ cast abi-encode --packed "(address, uint256)" 0x0000000000000000000000000000000000000002 1
        // 0x00000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000001
        // 生成签名
        // cast wallet sign $(cast k 0x00000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000) --account ethdev
        // cast wallet sign $(cast k 0x00000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000001) --account ethdev
        whitelist[0] = WhiteUser({
            account: 0x0000000000000000000000000000000000000001,
            tokenId: 0,
            signature: hex"fffe3a3fb47c157c091c483682adc669c21c020c404e5a5445d5aef90adbabbb139d814dd997d67e61f64555e8cc273bfa70c0d36a885c7f1b6cadbe4a08166a1c"
        });
        whitelist[1] = WhiteUser({
            account: 0x0000000000000000000000000000000000000002,
            tokenId: 1,
            signature: hex"7339b4226f7dc5e22bacc3bba3c28fc745cd8c4d71eaba4b55593317a1d41b2715d68f1b0b64f2d9b2895c01c2504af3e20f21bdaad38c897696d6863fe8ff9d1b"
        });
        whitelist[2] = WhiteUser({
            account: 0x0000000000000000000000000000000000000003,
            tokenId: 1,
            signature: hex"7339b4226f7dc5e22bacc3bba3c28fc745cd8c4d71eaba4b55593317a1d41b2715d68f1b0b64f2d9b2895c01c2504af3e20f21bdaad38c897696d6863fe8ff9d1b"
        });
    }

    function testValidateSignature() public view {
        assertTrue(ECDSA.verify(signedMsg, signature, signer));
    }

    function testNFTWhiteList() public {
        nft.mint(whitelist[0].account, whitelist[0].tokenId, whitelist[0].signature);
        nft.mint(whitelist[1].account, whitelist[1].tokenId, whitelist[1].signature);
        vm.expectRevert("Already minted!");
        nft.mint(whitelist[1].account, whitelist[1].tokenId, whitelist[1].signature);
    }

    function testNFTWhiteListFail() public {
        vm.expectRevert("Invalid signature");
        nft.mint(whitelist[2].account, whitelist[2].tokenId, whitelist[2].signature);
    }
}
