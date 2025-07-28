// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import "@openzeppelin/token/ERC20/IERC20.sol";

/// @notice 向多个地址转账ERC20代币
contract Airdrop {
    mapping(address => uint256) failTransferList;

    /// @notice 向多个地址转账ERC20代币，使用前需要先授权
    ///
    /// @param _token 转账的ERC20代币地址
    /// @param _addresses 空投地址数组
    /// @param _amounts 代币数量数组（每个地址的空投数量）
    function multiTransferToken(address _token, address[] calldata _addresses, uint256[] calldata _amounts) external {
        // 检查: _addresses 和 _amounts 数组长度相同
        require(_addresses.length == _amounts.length, "Lengths of addresses and amounts must match");

        IERC20 token = IERC20(_token);
        uint256 _amountSum = getSum(_amounts); // 计算空头代币总量
        // 检查: 授权代币数量 > 空投代币数量
        require(token.allowance(msg.sender, address(this)) >= _amountSum, "Insufficient allowance for airdrop");

        // 循环发送空投
        for (uint256 i = 0; i < _addresses.length; i++) {
            token.transferFrom(msg.sender, _addresses[i], _amounts[i]);
        }
    }

    function getSum(uint256[] memory _amounts) internal pure returns (uint256) {
        uint256 sum = 0;
        for (uint256 i = 0; i < _amounts.length; i++) {
            sum += _amounts[i];
        }
        return sum;
    }

    // 向多个地址转账ETH
    function multiTransferETH(address payable[] calldata _addresses, uint256[] calldata _amounts) public payable {
        // 检查: _addresses 和 _amounts 数组长度相同
        require(_addresses.length == _amounts.length, "Lengths of addresses and amounts must match");
        uint256 _amountSum = getSum(_amounts); // 计算空头ETH总量
        require(msg.value == _amountSum, "Insufficient ETH sent for airdrop");
        // 循环发送eth
        for (uint256 i = 0; i < _addresses.length; i++) {
            (bool success,) = _addresses[i].call{value: _amounts[i]}("");
            // 失败转账记录
            if (!success) {
                failTransferList[_addresses[i]] += _amounts[i];
            }
        }
    }

    // 给空头失败的用户提供主动操作的入口
    function withdrawFromFailList(address _to) public {
        uint256 failAmount = failTransferList[msg.sender];
        require(failAmount > 0, "No failed transfers for this address");
        failTransferList[msg.sender] = 0;
        (bool success,) = _to.call{value: failAmount}("");
        require(success, "Fail withdraw");
    }
}
