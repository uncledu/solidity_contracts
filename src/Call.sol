// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract ContractA{
  event Log(uint amount, uint gas);
  uint public _a = 0; 
  uint256 _x = 0;

  receive() external payable {

  }

  function getBalance() view public returns(uint) {
    return address(this).balance;
  }

  function setA(uint a) external payable {
    _a = a;
    if (msg.value>0){
      emit Log(msg.value, gasleft());
    }
  }

  function getA() view public returns(uint) {
    return _a;
  }
}


contract Call {
  event Res(bool success, bytes data);

  function callSetA(address payable _addr, uint a) external payable {
    (bool success, bytes memory data) = _addr.call{value: msg.value}(
      abi.encodeWithSignature("setA(uint256)", a) // alias类型也需要写出完整的类型，否则计算签名会失败
    );
    emit Res(success, data);
    require(success==true, "call failed");
  }
  
  function callGetA(address payable _addr) external returns(uint) {
    (bool success, bytes memory data) = _addr.staticcall(
      abi.encodeWithSignature("getA()")
    );
    emit Res(success, data); //emit Res(success: true, data: 0x0000000000000000000000000000000000000000000000000000000000000064)
    require(success==true, "call failed");
    return abi.decode(data, (uint));
  }

  function callNonExistentFunction(address payable _addr) external returns(uint) {
    (bool success, bytes memory data) = _addr.call(
      abi.encodeWithSignature("nonExistentFunction()")
    );
    emit Res(success, data);
    require(success==false, "call failed");
    require(data.length==0, "call failed");
    return abi.decode(data, (uint));
  }
}
