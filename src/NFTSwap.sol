// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IERC721} from "@openzeppelin/token/ERC721/IERC721.sol";
import {IERC721Receiver} from "@openzeppelin/token/ERC721/IERC721Receiver.sol";
import {WTFApe} from "./WTFApe.sol";

contract NFTSwap is IERC721Receiver {
    event List(address indexed seller, address indexed nftAddr, uint256 indexed tokenId, uint256 price);

    event Purchase(address indexed buyer, address indexed nftAddr, uint256 indexed tokenId, uint256 price);

    event Revoke(address indexed seller, address indexed nftAddr, uint256 indexed tokenId);

    event Update(address indexed seller, address indexed nftAddr, uint256 indexed tokenId, uint256 newPrice);

    // 定义order
    struct Order {
        address owner;
        uint256 price;
    }

    // NFT Order
    mapping(address => mapping(uint256 => Order)) public nftList;

    fallback() external payable {}
    receive() external payable {}
    // 挂单: 卖家上架NFT,合约地址为_nftAddr, tokenId为_nftTokenId,价格为_price(单位为wei)

    function list(address _nftAddr, uint256 _tokenId, uint256 _price) public {
        IERC721 _nft = IERC721(_nftAddr); // 声明IERC721接口合约变量
        require(_nft.getApproved(_tokenId) == address(this), "Need Approval");
        require(_price > 0);

        Order storage _order = nftList[_nftAddr][_tokenId]; // 设置nft持有人跟价格
        _order.owner = msg.sender;
        _order.price = _price;

        // 将NFT转移到合约地址
        _nft.safeTransferFrom(msg.sender, address(this), _tokenId);

        emit List(msg.sender, _nftAddr, _tokenId, _price);
    }

    // 购买: 买家购买NFT,合约为_nftAddr, tokenId为_nftTokenId, 调用函数时需要附带ETH
    function purchase(address _nftAddr, uint256 _nftTokenId) public payable {
        Order storage _order = nftList[_nftAddr][_nftTokenId];
        require(_order.price > 0, "Invalid Price");
        require(msg.value >= _order.price, "Not Enough ETH");

        IERC721 _nft = IERC721(_nftAddr);
        require(_nft.ownerOf(_nftTokenId) == address(this), "Invalid Order"); // NFT必须在合约地址上

        // NFT转给买家
        _nft.safeTransferFrom(address(this), msg.sender, _nftTokenId);
        // 将ETH转给卖家
        payable(_order.owner).transfer(_order.price);

        // 如果有多余eth,退给买家
        if (msg.value > _order.price) {
            payable(msg.sender).transfer(msg.value - _order.price);
        }

        emit Purchase(msg.sender, _nftAddr, _nftTokenId, _order.price);
        // 清理order
        delete nftList[_nftAddr][_nftTokenId];
    }

    // 撤单: 卖家取消挂单
    function revoke(address _nftAddr, uint256 _nftTokenId) public {
        Order storage _order = nftList[_nftAddr][_nftTokenId];
        require(_order.owner == msg.sender, "Not Owner");
        IERC721 _nft = IERC721(_nftAddr);
        require(_nft.ownerOf(_nftTokenId) == address(this), "Invalid Order");

        // 将NFT转回卖家
        _nft.safeTransferFrom(address(this), msg.sender, _nftTokenId);
        // 删除order
        delete nftList[_nftAddr][_nftTokenId];
    }

    // 调整价格: 买家调整价格
    function update(address _nftAddr, uint256 _nftTokenId, uint256 _newPrice) public {
        require(_newPrice > 0, "Invalid Price");
        Order storage _order = nftList[_nftAddr][_nftTokenId];
        require(_order.owner == msg.sender, "Not Owner");

        IERC721 _nft = IERC721(_nftAddr);
        require(_nft.ownerOf(_nftTokenId) == address(this), "Invalid Order");

        _order.price = _newPrice;

        emit Update(msg.sender, _nftAddr, _nftTokenId, _newPrice);
    }

    // 实现IERC721Receiver
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
        external
        override
        returns (bytes4)
    {
        return IERC721Receiver.onERC721Received.selector;
    }
}
