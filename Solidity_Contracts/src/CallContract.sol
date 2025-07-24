
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract ContractA{
  event Log(uint amount, uint gas);
  uint public _a = 0; 

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


contract CallContract {
  function callSetA(address _contractAddress, uint _a) external payable {
    ContractA(_contractAddress).setA(_a);
    // ContractA(_contractAddress).setA{value: msg.value}(_a);
  }

  function callGetA(ContractA _contractAddress) external view returns(uint a) {
    a = _contractAddress.getA();
    // return a;
  }

  function callSetA2(address _contractAddress) external view returns(uint a) {
    ContractA contractA = ContractA(_contractAddress);
    a = contractA.getA();
  }

  function setTransferETH(address _contractAddress, uint256 _value) external payable {
    ContractA(_contractAddress).setA{value: _value}(0);
  }
}
