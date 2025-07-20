// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin-contracts/utils/cryptography/EIP712.sol";

contract Voting is EIP712 {
    struct Vote {
        address voter;
        bool support;
        uint256 proposalId;
    }
    constructor() EIP712("Voting", "1") {}

    // 生成符合 EIP - 712 标准的哈希值
    // 首先，使用 keccak256 对结构体的类型字符串进行哈希，得到类型哈希。
    // 然后，使用 abi.encode 将结构体的字段值按照类型顺序进行编码，并再次使用 keccak256 对编码后的数据进行哈希，得到结构体哈希 structHash。
    // 最后，调用 _hashTypedDataV4 函数，将结构体哈希与域哈希相结合，生成最终符合 EIP - 712 标准的哈希值
    function hashVote(Vote memory vote) public view returns (bytes32) {
        return
            _hashTypedDataV4(
                keccak256(
                    abi.encode(
                        keccak256(
                            "Vote(address voter,bool support,uint256 proposalId)"
                        ),
                        vote.voter,
                        vote.support,
                        vote.proposalId
                    )
                )
            );
    }
}
