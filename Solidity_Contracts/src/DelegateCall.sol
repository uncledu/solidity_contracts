// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// delegatecall和call类似，都是低级函数
// call: B call C, 上下文为 C (msg.sender = B, C中的状态变量受影响)
// delegatecall: B delegatecall C, 上下文为B (msg.sender = A, B中的状态变量受影响)
// 注意B和C的数据存储布局必须相同！变量类型、声明的前后顺序要相同，不然会搞砸合约。


contract C {
  uint public n;
  address public sender;

  function setN(uint256 _n) external {
    n = _n;
    sender = msg.sender;
  }

  function getN() public view returns (uint) {
    return n;
  }
}

// 发起delegatecall的合约B
contract B {
  uint public n;
  address public sender;

  function getN() public view returns (uint) {
    return n;
  }
  // 通过call来调用C的setN函数，将该表合约C的状态变量
  function callSetN(address _addr, uint _n) external returns (bool, bytes memory){
    (bool success, bytes memory data) = _addr.call(abi.encodeWithSignature("setN(uint256)", _n));
    return (success, data);
  }
  // 通过delegatecall来调用C的setN函数，将该合约B的状态变量
  function delegatecallSetN(address _addr, uint _n) external returns (bool, bytes memory) {
    (bool success, bytes memory data) = _addr.delegatecall(abi.encodeWithSignature("setN(uint256)", _n));
    return (success, data);
  }
}
