// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script, console} from "forge-std/Script.sol";
import {A, B} from "../src/LowLevelCall.sol";

    contract CreatedContract {
        uint256 public value;
        constructor(uint256 _value) {
            value = _value;
        }
    }

  contract Create2Example {
    // 被创建的合约
    function deployContract(uint256 _value, bytes32 _salt) public returns (address) {
        bytes memory initCode = abi.encodePacked(type(CreatedContract).creationCode, abi.encode(_value));
        return address(uint160(uint256(keccak256(abi.encodePacked(
            bytes1(0xff),
            address(this),
            _salt,
            keccak256(initCode)
        )))));
    }
  }
contract LowLevelCallScript is Script {
    // A internal a;
    //
    // function run() public {
    //     vm.startBroadcast();
    //
    //     bytes32 salt = keccak256("fist a");
    //     bytes memory aBytecode = type(A).creationCode;
    //     assembly {
    //         expectedAddr := create2(0, add(aBytecode, 0x20), mload(aBytecode), salt)
    //     }
    //     a = A(expectedAddr);
    //     new A{salt: salt}();
    //     require(address(a) == cAddr, "should be equal a cAddr");
    //     vm.stopBroadcast();
    // }
  function run() public{
    Create2Example example = new Create2Example();
        uint256 value = 10;
        bytes32 salt = keccak256("testSalt");
        address expectedAddress = example.deployContract(value, salt);
        bytes memory initCode = abi.encodePacked(type(CreatedContract).creationCode, abi.encode(value));
        address createdAddress = address(uint160(uint256(keccak256(abi.encodePacked(
            bytes1(0xff),
            address(example),
            salt,
            keccak256(initCode)
        )))));
        require(createdAddress == expectedAddress, "Addresses do not match");
  }

}

