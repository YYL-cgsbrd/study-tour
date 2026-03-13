# 🛠️ Foundry 作弊码（Cheatcodes）完全指南

## 📖 什么是作弊码？

作弊码是 Foundry 提供的特殊函数，**只能在测试环境中使用**，用来模拟区块链的各种状态和行为。它们都以 `vm.` 开头。

---

## 🎯 最常用的作弊码（优先级排序）

### 1. 模拟调用者（最常用）

| 作弊码 | 作用 | 示例 |
|--------|------|------|
| `vm.prank(address)` | **下一次调用**模拟为某地址 | `vm.prank(alice); fundMe.fund();` |
| `vm.startPrank(address)` | **之后所有调用**模拟为某地址 | `vm.startPrank(alice); fundMe.fund(); fundMe.withdraw();` |
| `vm.stopPrank()` | 停止模拟 | `vm.stopPrank();` |

**为什么重要**：测试不同用户的行为，比如非 owner 不能提款

---

### 2. 创建测试账户

| 作弊码 | 作用 | 示例 |
|--------|------|------|
| `makeAddr(string)` | 根据字符串生成**确定性的地址** | `address alice = makeAddr("alice");` |
| `address(uint160(uint256(keccak256("bob")))` | 手动生成地址（不常用） | `address bob = address(0x123);` |

**为什么重要**：避免硬编码地址，测试可读性更强

---

### 3. 操作账户余额

| 作弊码 | 作用 | 示例 |
|--------|------|------|
| `vm.deal(address, uint256)` | 给地址发送 ETH | `vm.deal(alice, 10 ether);` |

**为什么重要**：测试需要 ETH 才能调用 `payable` 函数

---

### 4. 断言 revert

| 作弊码 | 作用 | 示例 |
|--------|------|------|
| `vm.expectRevert()` | 期待下一次调用失败（不指定原因） | `vm.expectRevert(); fundMe.withdraw();` |
| `vm.expectRevert(bytes)` | 期待特定的 revert 信息 | `vm.expectRevert("didn't send enough eth");` |
| `vm.expectRevert(bytes4)` | 期待特定的错误 selector | `vm.expectRevert(FundMe__notOwner.selector);` |
| `vm.expectPartialRevert(bytes4)` | 只检查错误类型，忽略参数 | `vm.expectPartialRevert(InsufficientBalance.selector);` |

**为什么重要**：测试错误处理逻辑是否正确

---

### 5. 操作时间和区块

| 作弊码 | 作用 | 示例 |
|--------|------|------|
| `vm.warp(uint256)` | 设置 `block.timestamp` | `vm.warp(block.timestamp + 7 days);` |
| `vm.roll(uint256)` | 设置 `block.number` | `vm.roll(block.number + 100);` |

**为什么重要**：测试时间锁、拍卖结束等场景

---

### 6. 断言事件

| 作弊码 | 作用 | 示例 |
|--------|------|------|
| `vm.expectEmit()` | 期待某个事件被发出 | `vm.expectEmit(); emit Transfer(alice, bob, 100); token.transfer(bob, 100);` |
| `vm.expectEmit(address)` | 期待指定合约的事件 | `vm.expectEmit(address(token));` |

**为什么重要**：验证事件是否正确发出

---

### 7. 断言调用

| 作弊码 | 作用 | 示例 |
|--------|------|------|
| `vm.expectCall(address, bytes)` | 期待某个地址被调用 | `vm.expectCall(address(priceFeed), abi.encodeWithSelector(priceFeed.latestRoundData.selector));` |

**为什么重要**：验证外部调用是否正确

---

### 8. 快照管理

| 作弊码 | 作用 | 示例 |
|--------|------|------|
| `vm.snapshot()` | 创建状态快照，返回 ID | `uint256 snapshot = vm.snapshot();` |
| `vm.revertTo(uint256)` | 恢复到快照状态 | `vm.revertTo(snapshot);` |

**为什么重要**：复杂测试中重置状态，避免重复部署

## 📝 完整测试模板

### 基础测试模板

```solidity
function testSomething() public {
    // 1. 准备环境
    address user = makeAddr("user");
    vm.deal(user, 10 ether);
    
    // 2. 模拟用户操作
    vm.prank(user);
    fundMe.fund{value: 1 ether}();
    
    // 3. 验证结果
    assertEq(fundMe.getAddressToAmountFunded(user), 1 ether);
    assertEq(fundMe.getFunder(0), user);
}

```

### 测试 revert 的模板

```solidity
function testOnlyOwnerCanWithdraw() public {
    // 1. 准备非 owner 用户
    address nonOwner = makeAddr("nonOwner");
    
    // 2. 期待 revert
    vm.expectRevert(FundMe__notOwner.selector);
    
    // 3. 模拟非 owner 调用
    vm.prank(nonOwner);
    fundMe.withdraw();
}
```

### 测试事件的模板

```solidity
function testFundEmitsEvent() public {
    // 1. 期待事件
    vm.expectEmit();
    emit Funded(msg.sender, 1 ether);  // 假设有 Funded 事件
    
    // 2. 执行操作
    fundMe.fund{value: 1 ether}();
}
```

---

## ⚠️ 常见错误和注意事项

### ❌ 错误：忘记 `vm.prank`

```solidity
function testFail() public {
    // 忘记模拟非 owner，实际是测试合约自己调用
    fundMe.withdraw();  // 可能意外通过
}
```

### ✅ 正确：先模拟再调用

```solidity
function testCorrect() public {
    address nonOwner = makeAddr("nonOwner");
    vm.prank(nonOwner);
    vm.expectRevert(FundMe__notOwner.selector);
    fundMe.withdraw();
}
```

### ❌ 错误：`vm.prank` 和调用之间插了其他代码

```solidity
function testFail() public {
    vm.prank(alice);
    console.log("calling...");  // ❌ 这行会打断 prank
    fundMe.fund();  // prank 失效
}
```

### ✅ 正确：prank 后直接调用

```solidity
function testCorrect() public {
    vm.prank(alice);
    fundMe.fund();  // ✅ prank 生效
}
```

### ❌ 错误：测试里用 `msg.sender` 代替模拟用户

```solidity
function testFail() public {
    fundMe.fund{value: 1 ether}();
    assertEq(fundMe.getAddressToAmountFunded(msg.sender), 1 ether);
    // 这是测试合约在存钱，不是用户！
}
```

### ✅ 正确：用 `makeAddr` 创建独立用户

```solidity
function testCorrect() public {
    address user = makeAddr("user");
    vm.deal(user, 1 ether);
    vm.prank(user);
    fundMe.fund{value: 1 ether}();
    assertEq(fundMe.getAddressToAmountFunded(user), 1 ether);
}
```

---

## 📊 常用组合速查表

| 测试场景 | 需要哪些作弊码 | 示例 |
|---------|----------------|------|
| 普通用户调用 | `makeAddr` + `vm.deal` + `vm.prank` | 测试存钱 |
| 非 owner 调用 | `makeAddr` + `vm.prank` + `vm.expectRevert` | 测试权限 |
| 时间敏感 | `vm.warp` + `vm.roll` | 测试拍卖结束 |
| 事件验证 | `vm.expectEmit` | 测试事件 |
| 外部调用 | `vm.expectCall` | 测试预言机调用 |
| 复杂状态 | `vm.snapshot` + `vm.revertTo` | 测试多个场景 |

---

## 🔗 官方文档链接

- [Foundry Book: 作弊码大全](https://book.getfoundry.sh/cheatcodes/)
- [Foundry GitHub](https://github.com/foundry-rs/foundry)

