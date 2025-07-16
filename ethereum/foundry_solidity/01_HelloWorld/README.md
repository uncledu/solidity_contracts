# Hello World工程
1. 初始化工程

使用forge来初始化项目，这里使用[soldeer]来做项目的依赖管理。
```sh
forge init
forge soldeer init
rm -rf lib
```

    foundry一开始是使用git的submodule来做依赖管理的。随着越来越多的本地依赖的需求产生，使用git submodule的方式并不能很方便与很好的满足，所以迁移到了[soldeer]的依赖管理方式。[soldeer]是一款用rust开发的solidity依赖管理工具，类似我们熟知的npm, cargo，它也有一个在线的包管理查询中心[soldeer.xyz](soldeer.xyz)

执行完上述初始化命令后，将会得到如下的目录结构
```sh
.
├── README.md
├── dependencies
│   └── forge-std-1.9.7
├── foundry.toml
├── remappings.txt
├── script
│   └── Counter.s.sol
├── soldeer.lock
├── src
│   └── Counter.sol
└── test
    └── Counter.t.sol
```

2. 修改代码

参考工程目录的代码，进行相关修改，这里可以先不要太在意语法，先照着修改与执行，体验一下整体过程。
也可以直接clone代码库。

3. 测试代码

执行测试指令, 注意，这里执行的测试是单元测试，并不会与链进行交互。
```sh
forge test

# 将会看到如下输出
[⠊] Compiling...
No files changed, compilation skipped

Ran 1 test for test/Hello.t.sol:HelloWorldTest
[PASS] test_sayHello() (gas: 23490)
Suite result: ok. 1 passed; 0 failed; 0 skipped; finished in 5.05ms (1.29ms CPU time)

Ran 1 test suite in 99.96ms (5.05ms CPU time): 1 tests passed, 0 failed, 0 skipped (1 total tests)
```
```

```

4. 链上测试

在上一步中，我们进行了合约的单元测试，当验证合约逻辑没有问题后，我们可以将合约部署到测试链上再次验证。
链上测试可以使用以太坊提供的几条测试链，不过他们都需要一些实际的测试代币，才能用于支付合约运行的gas费用，而测试代币虽然可以从免费的faucet领取，但是大部分领取水龙头要求你的账户在mainnet上需要包含至少0.001eth。这对于部分初学者来说可能比较麻烦。恰好foundry为我们提供了`anvil`工具，它可以在本地运行一个以太坊的测试链, 使用`anvil`可以很方便的进行链上测试。

启动`anvil`，并将其运行在本地的8545端口上。
```sh
anvil
# 将会看到如下输出
                             _   _
                            (_) | |
      __ _   _ __   __   __  _  | |
     / _` | | '_ \  \ \ / / | | | |
    | (_| | | | | |  \ V /  | | | |
     \__,_| |_| |_|   \_/   |_| |_|

    1.2.3-stable (a813a2cee7 2025-06-08T15:42:50.507050000Z)
    https://github.com/foundry-rs/foundry

Available Accounts
==================

(0) 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 (10000.000000000000000000 ETH)
(1) 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 (10000.000000000000000000 ETH)

Private Keys
==================

(0) 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
(1) 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d
```

anvil会提供10个测试地址和他们的私钥，每个地址里都有预置的10000ETH，可以方便的用来做链上测试。
接下来，可以很方便的进行链上测试
```sh
forge script script/Hello.s.sol --fork-url http://localhost:8545 --broadcast --interactives 1

# 将会看到如下输出，中间需要你输入一个私钥，可以从上面提到的anvil提供的10个测试账号私钥里任选一个
[⠊] Compiling...
[⠰] Compiling 3 files with Solc 0.8.30
[⠔] Solc 0.8.30 finished in 324.16ms
Compiler run successful!
Enter private key:
Script ran successfully.

## Setting up 1 EVM.

==========================

Chain 31337

Estimated gas price: 2.000000001 gwei

Estimated total gas used for script: 461433

Estimated amount required: 0.000922866000461433 ETH

==========================

##### anvil-hardhat
✅  [Success] Hash: 0xdf144a93a267ac0a7715ae10634cf09ee0db3b76e65e79365bd3805e582af2df
Contract Address: 0x5FbDB2315678afecb367f032d93F642f64180aa3
Block: 1
Paid: 0.000354949000354949 ETH (354949 gas * 1.000000001 gwei)

✅ Sequence #1 on anvil-hardhat | Total Paid: 0.000354949000354949 ETH (354949 gas * avg 1.000000001 gwei)


==========================

ONCHAIN EXECUTION COMPLETE & SUCCESSFUL.

Transactions saved to: /Users/fantasy/Documents/workspace/blockchain/ethereum/foundry_solidity/01_HelloWorld/broadcast/Hello.s.sol/31337/run-latest.json

Sensitive values saved to: /Users/fantasy/Documents/workspace/blockchain/ethereum/foundry_solidity/01_HelloWorld/cache/Hello.s.sol/31337/run-latest.json
```
```
```

至此，我们完成了第一个以太坊智能合约的开发与测试。假设这是一个真实的合约，我们可以将其部署到主网或其他测试网进行实际的使用。






[soldeer]: https://soldeer.xyz/
