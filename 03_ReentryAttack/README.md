# 重放攻击

本工程旨在演示和测试 Solidity 智能合约中的重入攻击（Reentrancy Attack）漏洞。通过构建一个易受攻击的合约（Victim）和一个攻击者合约（Attacker），开发者可以直观地观察到重入攻击的原理与危害，并学习如何防御此类安全风险。

## 工程结构与实现思路

- **Victim 合约**：模拟一个典型的易受重入攻击的合约，通常包含如提现（withdraw）等外部调用逻辑，但未正确更新内部状态，导致攻击者可多次重入提取资金。
- **Attacker 合约**：实现攻击逻辑，通过 fallback 或 receive 函数在 Victim 合约转账时反复调用提现函数，实现多次盗取资金。
- **脚本与测试**：通过脚本自动部署 Victim 和 Attacker，并执行攻击流程，验证重入攻击的实际效果。

## 技术要点

- 利用 Foundry 工具链（forge-std）进行合约开发、测试与脚本自动化。
- 通过 broadcast 目录下的交易记录，可以看到 Victim 和 Attacker 的部署与交互过程。
- 代码中采用了标准的测试基类和脚本基类，便于扩展和集成更多安全测试用例。

## 适用场景

本工程适合 Solidity 初学者、安全工程师或智能合约开发者，用于理解重入攻击的攻击面、复现攻击过程，并学习防御措施（如使用 Checks-Effects-Interactions 模式或引入重入锁）。

---

通过实际运行和分析本工程，开发者可以加深对 Solidity 安全开发的理解，提升智能合约的安全性。

## 详细说明

```sh
# 单测
forge test 

# 本地anvil链上测试
anvil
forge script script/Victim.s.sol --fork-url http://localhost:8545 --broadcast --unlocked
```
```
```
