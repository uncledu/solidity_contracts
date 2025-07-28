// SPDX-License-Identifier: MITjjj
pragma solidity ^0.8.0;

import {IERC721} from "@openzeppelin/token/ERC721/IERC721.sol";
import {ERC721Utils} from "@openzeppelin/token/ERC721/utils/ERC721Utils.sol";
import {Context} from "@openzeppelin/utils/Context.sol";
/// @title MyNFT conftrct

contract MyNFT is Context, IERC721 {
    error ERC721InvalidOwner(address owner);

    error ERC721InvalidReceiver(address receiver);
    // Mapping from token ID to owner address

    error ERC721NonexistentToken(uint256 tokenId);

    error ERC721IncorrectOwner(address sender, uint256 tokenId, address owner);

    error ERC721InsufficientApproval(address operator, uint256 tokenId);

    mapping(uint256 => address) private _owners;

    // Mapping from owner address to number of owned tokens
    mapping(address => uint256) private _balances;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

    mapping(address owner => mapping(address operator => bool)) private _operatorApprovals;
    // Event declarations
    // event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    // event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /// return the balance of owner's token
    /// @inheritdoc IERC721
    function balanceOf(address owner) external view override returns (uint256) {
        if ((owner) == address(0)) {
            revert ERC721InvalidOwner(address(0));
        }
        return _balances[owner];
    }

    /// @inheritdoc IERC721
    function ownerOf(uint256 tokenId) external view override returns (address owner) {
        return _owners[tokenId];
    }

    /// @inheritdoc IERC721
    function safeTransferFrom(address from, address to, uint256 tokenId) external override {
        safeTransferFrom(from, to, tokenId, "");
    }

    /// @inheritdoc IERC721
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public virtual {
        transferFrom(from, to, tokenId);
        ERC721Utils.checkOnERC721Received(msg.sender, from, to, tokenId, data);
    }

    function transferFrom(address from, address to, uint256 tokenId) public override {
        if (to == address(0)) {
            revert ERC721InvalidReceiver(address(0));
        }
        address previousOwner = _update(to, tokenId, _msgSender());
    }

    function _update(address to, uint256 tokenId, address auth) internal virtual returns (address) {
        address from = _ownerOf(tokenId);

        if (auth != address(0)) {
            _checkAuthorized(from, auth, tokenId);
        }
    }

    function _ownerOf(uint256 tokenId) internal view returns (address) {
        address owner = _owners[tokenId];
        if (owner == address(0)) {
            revert ERC721InvalidOwner(owner);
        }
        return owner;
    }

    function _checkAuthorized(address owner, address spender, uint256 tokenId) internal view virtual {
        if (!_isAuthorized(owner, spender, tokenId)) {
            if (owner == address(0)) {
                revert ERC721NonexistentToken(tokenId);
            } else {
                revert ERC721InsufficientApproval(spender, tokenId);
            }
        }
    }

    function _isAuthorized(address owner, address spender, uint256 tokenId) internal view virtual returns (bool) {
        return spender != address(0)
            && (owner == spender || isApprovedForAll(owner, spender) || _getApproved(tokenId) == spender);
    }

    function isApprovedForAll(address owner, address operator) public view virtual returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function _getApproved(uint256 tokenId) internal view virtual returns (address) {
        return _tokenApprovals[tokenId];
    }
}
