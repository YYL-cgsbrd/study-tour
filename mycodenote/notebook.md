```markdown
# Updraft Cyfrin 课程：智能合约部署完整操作指南

## 📋 环境准备

### 1. 启动本地测试节点

```bash
# 在终端中启动 Anvil（Foundry自带的本地测试网）
anvil

# 启动后你会看到：
# - 10个测试账户地址（每个有10000 ETH）
# - 对应的私钥
# - RPC URL: http://127.0.0.1:8545
# - Chain ID: 31337
```

> **注意**：保持这个终端运行，不要关闭。打开新的终端进行后续操作。

---

## 🔧 第一部分：使用 forge create 部署（命令行方式）

### 步骤1：编译合约

```bash
# 确保你的合约没问题
forge build
```

### 步骤2：部署到 Anvil

```bash
# 方法1：交互式输入私钥（推荐初学者使用）
forge create SimpleStorage --interactive
# 系统会提示你粘贴私钥（粘贴后看不到字符，直接按回车即可）

# 方法2：直接指定私钥（仅用于测试，了解即可）
forge create SimpleStorage --rpc-url http://127.0.0.1:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

# 方法3：不指定rpc-url（默认使用Anvil）
forge create SimpleStorage --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

### 步骤3：验证部署

```bash
# 在运行anvil的终端中，你应该能看到类似输出：
# Transaction: 0x40d2ca8f0d680f098c7d5e3c127ef1ce1207ef439ba6e163c2042483e15998a6
# Contract created: 0x5fbdb2315678afecb367f032d93f642f64180aa3
# Gas used: 357076
```

---

## 📝 第二部分：使用 Solidity 脚本部署（推荐方式）

### 步骤1：创建部署脚本

创建文件 `script/DeploySimpleStorage.s.sol`：

```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol";

contract DeploySimpleStorage is Script {
    function run() external returns (SimpleStorage) {
        // startBroadcast() 之后的交易会被发送到区块链
        vm.startBroadcast();
        
        // 创建新的合约实例
        SimpleStorage simpleStorage = new SimpleStorage();
        
        // stopBroadcast() 标记交易列表的结束
        vm.stopBroadcast();
        
        // 返回部署的合约地址
        return simpleStorage;
    }
}
```

### 步骤2：模拟运行脚本

```bash
# 不指定RPC URL时，Foundry会自动启动临时Anvil实例
forge script script/DeploySimpleStorage.s.sol

# 你应该看到：
# Script ran successfully.
# Gas used: 338569
# == Return ==
# 0: contract SimpleStorage 0x90193C961A926261B756D1E5bb255e67ff9498A1
```

### 步骤3：模拟运行（指定RPC URL）

```bash
# 先确保Anvil在运行
forge script script/DeploySimpleStorage.s.sol --rpc-url http://127.0.0.1:8545

# 这会显示模拟结果和Gas估算，但不会真正部署
```

### 步骤4：实际部署到 Anvil

```bash
# 添加 --broadcast 参数真正部署
forge script script/DeploySimpleStorage.s.sol --rpc-url http://127.0.0.1:8545 --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

# 成功后会在 broadcast 文件夹生成部署记录
```

---

## 🔐 第三部分：安全的私钥管理

### 方法1：使用 .env 文件（开发环境适用）

**步骤1：创建 .env 文件**

```bash
# 在项目根目录创建 .env 文件
touch .env

# 用编辑器打开，添加以下内容：
PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
RPC_URL=http://127.0.0.1:8545
```

**步骤2：确保 .gitignore 包含 .env**

```bash
# 检查 .gitignore 文件，确保有这一行：
.env
```

**步骤3：加载环境变量**

```bash
# 加载 .env 文件到当前终端
source .env

# 验证变量是否加载成功
echo $PRIVATE_KEY
echo $RPC_URL
```

**步骤4：使用环境变量部署**

```bash
forge script script/DeploySimpleStorage.s.sol --rpc-url $RPC_URL --broadcast --private-key $PRIVATE_KEY
```

### 方法2：使用 ERC2335 密钥库（推荐安全方式）

**步骤1：导入私钥到密钥库**

```bash
# 导入私钥并设置密码
cast wallet import myaccount --interactive
# 系统会提示：
# - 粘贴你的私钥
# - 设置一个密码（用于加密存储）
```

**步骤2：查看已导入的账户**

```bash
cast wallet list
# 显示所有已配置的钱包
```

**步骤3：使用密钥库部署**

```bash
# 使用账户名部署，系统会提示输入密码
forge script script/DeploySimpleStorage.s.sol --rpc-url http://127.0.0.1:8545 --broadcast --account myaccount --sender 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266
```

**步骤4：清理终端历史**

```bash
# 清除终端历史记录，防止私钥残留
history -c
```

---

## 🔄 第四部分：与已部署合约交互

### 步骤1：获取合约地址

```bash
# 从部署输出中复制合约地址，例如：
CONTRACT_ADDRESS=0x5fbdb2315678afecb367f032d93f642f64180aa3
```

### 步骤2：发送交易（修改状态）

```bash
# 调用 store 函数，存储数字 42
cast send $CONTRACT_ADDRESS "store(uint256)" 42 --rpc-url $RPC_URL --private-key $PRIVATE_KEY

# 存储其他数字
cast send $CONTRACT_ADDRESS "store(uint256)" 1337 --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

### 步骤3：读取数据（查询状态）

```bash
# 调用 retrieve 函数，获取存储的值
cast call $CONTRACT_ADDRESS "retrieve()"

# 返回的是十六进制，例如：0x0000000000000000000000000000000000000000000000000000000000000539
```

### 步骤4：转换十六进制为十进制

```bash
# 将十六进制转换为十进制
cast --to-base 0x0000000000000000000000000000000000000000000000000000000000000539 dec
# 返回：1337
```

### 步骤5：一步完成读取和转换

```bash
# 使用 --to-dec 参数直接获取十进制结果
cast call $CONTRACT_ADDRESS "retrieve()" --rpc-url $RPC_URL | cast --to-dec
```

---

## 🌐 第五部分：部署到 Sepolia 测试网

### 步骤1：在 Alchemy 创建应用

1. 访问 [alchemy.com](https://alchemy.com) 注册账号
2. 点击 "Create App"
3. 填写名称（如 "Sepolia Testing"）
4. 选择链：Ethereum
5. 选择网络：Sepolia
6. 创建后点击 "View Key"，复制 HTTPS endpoint

### 步骤2：准备测试网环境变量

```bash
# 编辑 .env 文件，添加 Sepolia 配置
SEPOLIA_RPC_URL=https://eth-sepolia.g.alchemy.com/v2/你的API密钥
PRIVATE_KEY=你的MetaMask测试网账户私钥  # 确保这个账户有Sepolia ETH
```

### 步骤3：加载环境变量

```bash
source .env
```

### 步骤4：部署到 Sepolia

```bash
# 部署到 Sepolia 测试网
forge script script/DeploySimpleStorage.s.sol --rpc-url $SEPOLIA_RPC_URL --broadcast --private-key $PRIVATE_KEY
```

### 步骤5：验证部署

```bash
# 从输出中找到交易哈希，例如：
# Transaction: 0x1234567890abcdef...

# 在浏览器中查看：
# https://sepolia.etherscan.io/tx/你的交易哈希
```

---

## 📚 常用命令速查表

| 命令 | 用途 | 示例 |
|------|------|------|
| `anvil` | 启动本地测试网 | `anvil` |
| `forge build` | 编译合约 | `forge build` |
| `forge create` | 直接部署 | `forge create SimpleStorage --interactive` |
| `forge script` | 脚本部署 | `forge script script/DeploySimpleStorage.s.sol --broadcast` |
| `cast send` | 发送交易 | `cast send $ADDRESS "store(uint256)" 42` |
| `cast call` | 读取数据 | `cast call $ADDRESS "retrieve()"` |
| `cast --to-base` | 进制转换 | `cast --to-base 0x123 dec` |
| `cast wallet import` | 导入私钥 | `cast wallet import myaccount --interactive` |
| `cast wallet list` | 查看密钥库 | `cast wallet list` |
| `history -c` | 清理历史 | `history -c` |

---

## ⚠️ 重要安全提醒

1. **永远不要**将带有真实资产的私钥以明文形式存储或使用
2. **永远不要**将私钥写在命令行中（会被历史记录保存）
3. **永远不要**将包含私钥的 `.env` 文件提交到 GitHub
4. 本地测试用的 Anvil 私钥是公开的，只用于开发
5. 使用 `--interactive` 或密钥库方式输入私钥
6. 定期清理终端历史：`history -c`

---

## ✅ 完整工作流程示例

```bash
# 1. 启动 Anvil（终端1）
anvil

# 2. 打开新终端（终端2）
cd your-project

# 3. 编译合约
forge build

# 4. 导入私钥到密钥库（只需做一次）
cast wallet import testaccount --interactive

# 5. 部署合约
forge script script/DeploySimpleStorage.s.sol --rpc-url http://127.0.0.1:8545 --broadcast --account testaccount --sender 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266

# 6. 复制部署的合约地址
CONTRACT=0x5fbdb2315678afecb367f032d93f642f64180aa3

# 7. 存储数据
cast send $CONTRACT "store(uint256)" 42 --rpc-url http://127.0.0.1:8545 --account testaccount

# 8. 读取数据
cast call $CONTRACT "retrieve()" --rpc-url http://127.0.0.1:8545 | cast --to-dec

# 9. 清理历史
history -c
```
