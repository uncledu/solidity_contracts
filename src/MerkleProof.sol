// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ERC721} from "@openzeppelin/token/ERC721/ERC721.sol";

// 一份拥有800个地址的白名单，更新一次所需的gas fee很容易超过1个ETH。
// 而由于Merkle Tree验证时，leaf和proof可以存在后端，链上仅需存储一
// 个root的值，非常节省gas，项目方经常用它来发放白名单。很多ERC721标
// 准的NFT和ERC20标准代币的白名单/空投都是利用Merkle Tree发出的，比
// 如optimism的空投。

contract MerkleTree is ERC721 {
    bytes32 public immutable root; // Merkle树的根哈希
    mapping(address => bool) public mintedAddress; // 记录已经mint的地址

    // 够早函数,初始化NFT合集的名称、代号、Merkle树的根
    constructor(string memory name, string memory symbol, bytes32 merkleRoot) ERC721(name, symbol) {
        root = merkleRoot;
    }

    // 利用Merkle树验证地址并完成mint
    function mint(address account, uint256 tokenId, bytes32[] calldata proof) external {
        require(_verify(_leaf(account), proof), "Invalid merkle proof"); // Merkle校验
        require(!mintedAddress[account], "Already minted"); // 确保地址未mint过

        mintedAddress[account] = true; // 标记地址已mint
        _mint(account, tokenId); // mint
    }

    // 计算Merkle树叶子节点哈希
    function _leaf(address account) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(account)); // 生成叶子节点哈希
    }

    // Merkle树验证,调用MerkleProof库的verify函数
    function _verify(bytes32 leaf, bytes32[] memory proof) internal view returns (bool) {
        return MerkleProof.verify(proof, root, leaf);
    }
}

library MerkleProof {
    /**
     * @dev 当通过`proof`和`leaf`重建出的`root`与给定的`root`相同时，返回true。
     * 在重建时,叶子节点对和元素都是排序好的.
     */
    function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
        return processProof(proof, leaf) == root;
    }

    /**
     * @dev Returns 通过Merkle树用`proof`和`leaf`重建出的`root`。当重建出的`root`与给定的`root`相同时，返回true。
     * 在重建时,叶子节点对和元素都是排序好的.
     */
    function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
        bytes32 computedHash = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            computedHash = _hashPair(computedHash, proof[i]);
        }
        return computedHash;
    }

    // Sorted Pair Hash a,b
    function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
        return a < b ? keccak256(abi.encodePacked(a, b)) : keccak256(abi.encodePacked(b, a));
    }
}
