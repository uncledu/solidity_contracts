// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import {NFTSwap} from "../src/NFTSwap.sol";
import {WTFApe} from "../src/WTFApe.sol";
import {IERC721Receiver} from "@openzeppelin/token/ERC721/IERC721Receiver.sol";

contract NFTSwapTest is Test, IERC721Receiver {
    NFTSwap swap;
    WTFApe ape;

    function setUp() public {
        swap = new NFTSwap();
        ape = new WTFApe("WTFApe", "WTFApe");
    }

    function testListAndPurchase() public {
        ape.mint(address(this), 1);
        ape.approve(address(swap), 1);

        swap.list(address(ape), 1, 10 ether);

        // Check if the NFT is listed
        address _nftAddr = address(ape);
        uint256 _tokenId = 1;

        (address owner, uint256 price) = swap.nftList(_nftAddr, _tokenId); // 设置nft持有人跟价格
        assertEq(owner, address(this));
        assertEq(price, 10 ether);

        // Purchase the NFT
        vm.deal(address(this), 20 ether); // Give enough ether to the contract
        swap.purchase{value: 10 ether}(address(ape), 1);

        // Check if the NFT is transferred
        assertEq(ape.ownerOf(1), address(this));
    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
        external
        override
        returns (bytes4)
    {
        return IERC721Receiver.onERC721Received.selector;
    }

    receive() external payable {}
}
