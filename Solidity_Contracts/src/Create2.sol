// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Pair{
  uint x = 0;
  address public factory; // 工厂合约地址
  address public token0; // 代币0
  address public token1; // 代币1

  constructor(uint _x) payable{
    x = _x;
    factory = msg.sender; // 设置工厂合约地址为部署者地址
  }

  function  initialize(address _token0, address _token1) external {
    require(msg.sender == factory, "FORBIDDEN: Only factory can initialize");
    token0 = _token0; // 设置代币0地址A
    token1 = _token1; // 设置代币1地址B
  }
}

contract PairFactory2{
    mapping(address => mapping(address => address)) public getPair; // 存储代币对地址
    address[] public allPairs; // 存储所有Pair对地址

    function createPair2(address _tokenA, address _tokenB, uint arg) external returns (address pairAddr) {
      require(_tokenA != _tokenB, "Identical addresses"); // 避免创建相同地址的代币对
      // 用tokenA跟tokenB地址计算salt
      (address token0, address token1) = _tokenA < _tokenB ? (_tokenA, _tokenB) : (_tokenB, _tokenA); 
      bytes32 salt = keccak256(abi.encodePacked(token0, token1));
      // 用CREATE2指令部署Pair合约
      Pair pair = new Pair{salt: salt}(arg);
      // 调用新合约的initialize方法
      pair.initialize(_tokenA, _tokenB);
      // 更新地址map
      pairAddr = address(pair);
      allPairs.push(pairAddr);
      getPair[_tokenA][_tokenB] = pairAddr;
      getPair[_tokenB][_tokenA] = pairAddr; // 反向映射]
    }
    
    function calculateAddr(address _tokenA, address _tokenB, uint arg) external view returns (address predictAddr) {
      require(_tokenA != _tokenB, "Identical addresses"); // 避免创建相同地址的代币对
      // 计算salt
      (address token0, address token1) = _tokenA < _tokenB ? (_tokenA, _tokenB) : (_tokenB, _tokenA); 
      bytes32 salt = keccak256(abi.encodePacked(token0, token1));
      predictAddr = address(uint160(uint(keccak256(abi.encodePacked(
        bytes1(0xff),
        address(this),
        salt,
        keccak256(
          abi.encodePacked(
            type(Pair).creationCode,
            abi.encode(arg) // 将arg作为构造函数参数传入
          )
        )
      )))));
    }
}
