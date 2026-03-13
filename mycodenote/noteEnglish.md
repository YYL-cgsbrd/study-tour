```markdown
# Updraft Cyfrin Course: Complete Guide to Smart Contract Deployment

## 📋 Environment Setup

### 1. Start Local Test Node

```bash
# Start Anvil (Foundry's built-in local testnet) in the terminal
anvil

# After starting, you will see:
# - 10 test account addresses (each with 10000 ETH)
# - Corresponding private keys
# - RPC URL: http://127.0.0.1:8545
# - Chain ID: 31337
```

> **Note**: Keep this terminal running, do not close it. Open a new terminal for subsequent operations.

---

## 🔧 Part 1: Deploying with forge create (Command Line Method)

### Step 1: Compile Contract

```bash
# Make sure your contract is correct
forge build
```

### Step 2: Deploy to Anvil

```bash
# Method 1: Interactive private key input (recommended for beginners)
forge create SimpleStorage --interactive
# The system will prompt you to paste your private key (characters won't show, just press Enter after pasting)

# Method 2: Directly specify private key (for testing only, just to understand)
forge create SimpleStorage --rpc-url http://127.0.0.1:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

# Method 3: Without specifying rpc-url (defaults to Anvil)
forge create SimpleStorage --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

### Step 3: Verify Deployment

```bash
# In the terminal running anvil, you should see output similar to:
# Transaction: 0x40d2ca8f0d680f098c7d5e3c127ef1ce1207ef439ba6e163c2042483e15998a6
# Contract created: 0x5fbdb2315678afecb367f032d93f642f64180aa3
# Gas used: 357076
```

---

## 📝 Part 2: Deploying with Solidity Scripts (Recommended Method)

### Step 1: Create Deployment Script

Create file `script/DeploySimpleStorage.s.sol`:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol";

contract DeploySimpleStorage is Script {
    function run() external returns (SimpleStorage) {
        // Transactions after startBroadcast() will be sent to the blockchain
        vm.startBroadcast();
        
        // Create new contract instance
        SimpleStorage simpleStorage = new SimpleStorage();
        
        // stopBroadcast() marks the end of the transaction list
        vm.stopBroadcast();
        
        // Return the deployed contract address
        return simpleStorage;
    }
}
```

### Step 2: Simulate Running Script

```bash
# When RPC URL is not specified, Foundry automatically starts a temporary Anvil instance
forge script script/DeploySimpleStorage.s.sol

# You should see:
# Script ran successfully.
# Gas used: 338569
# == Return ==
# 0: contract SimpleStorage 0x90193C961A926261B756D1E5bb255e67ff9498A1
```

### Step 3: Simulate Run (Specify RPC URL)

```bash
# First make sure Anvil is running
forge script script/DeploySimpleStorage.s.sol --rpc-url http://127.0.0.1:8545

# This will show simulation results and gas estimates, but won't actually deploy
```

### Step 4: Actually Deploy to Anvil

```bash
# Add --broadcast parameter to actually deploy
forge script script/DeploySimpleStorage.s.sol --rpc-url http://127.0.0.1:8545 --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

# After success, deployment records will be generated in the broadcast folder
```

---

## 🔐 Part 3: Secure Private Key Management

### Method 1: Using .env File (Suitable for Development)

**Step 1: Create .env File**

```bash
# Create .env file in the project root directory
touch .env

# Open with an editor and add the following:
PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
RPC_URL=http://127.0.0.1:8545
```

**Step 2: Ensure .gitignore Contains .env**

```bash
# Check .gitignore file, make sure this line exists:
.env
```

**Step 3: Load Environment Variables**

```bash
# Load .env file into current terminal
source .env

# Verify variables loaded successfully
echo $PRIVATE_KEY
echo $RPC_URL
```

**Step 4: Deploy Using Environment Variables**

```bash
forge script script/DeploySimpleStorage.s.sol --rpc-url $RPC_URL --broadcast --private-key $PRIVATE_KEY
```

### Method 2: Using ERC2335 Keystore (Recommended Secure Method)

**Step 1: Import Private Key to Keystore**

```bash
# Import private key and set a password
cast wallet import myaccount --interactive
# The system will prompt:
# - Paste your private key
# - Set a password (for encrypted storage)
```

**Step 2: View Imported Accounts**

```bash
cast wallet list
# Shows all configured wallets
```

**Step 3: Deploy Using Keystore**

```bash
# Deploy using account name, system will prompt for password
forge script script/DeploySimpleStorage.s.sol --rpc-url http://127.0.0.1:8545 --broadcast --account myaccount --sender 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266
```

**Step 4: Clear Terminal History**

```bash
# Clear terminal history to prevent private key remnants
history -c
```

---

## 🔄 Part 4: Interacting with Deployed Contracts

### Step 1: Get Contract Address

```bash
# Copy contract address from deployment output, for example:
CONTRACT_ADDRESS=0x5fbdb2315678afecb367f032d93f642f64180aa3
```

### Step 2: Send Transaction (Modify State)

```bash
# Call store function, store number 42
cast send $CONTRACT_ADDRESS "store(uint256)" 42 --rpc-url $RPC_URL --private-key $PRIVATE_KEY

# Store other numbers
cast send $CONTRACT_ADDRESS "store(uint256)" 1337 --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

### Step 3: Read Data (Query State)

```bash
# Call retrieve function, get stored value
cast call $CONTRACT_ADDRESS "retrieve()"

# Returns hexadecimal, for example: 0x0000000000000000000000000000000000000000000000000000000000000539
```

### Step 4: Convert Hexadecimal to Decimal

```bash
# Convert hexadecimal to decimal
cast --to-base 0x0000000000000000000000000000000000000000000000000000000000000539 dec
# Returns: 1337
```

### Step 5: Read and Convert in One Step

```bash
# Use --to-dec parameter to get decimal result directly
cast call $CONTRACT_ADDRESS "retrieve()" --rpc-url $RPC_URL | cast --to-dec
```

---

## 🌐 Part 5: Deploying to Sepolia Testnet

### Step 1: Create an App on Alchemy

1. Visit [alchemy.com](https://alchemy.com) to register an account
2. Click "Create App"
3. Enter a name (e.g., "Sepolia Testing")
4. Select chain: Ethereum
5. Select network: Sepolia
6. After creation, click "View Key" and copy the HTTPS endpoint

### Step 2: Prepare Testnet Environment Variables

```bash
# Edit .env file, add Sepolia configuration
SEPOLIA_RPC_URL=https://eth-sepolia.g.alchemy.com/v2/YOUR_API_KEY
PRIVATE_KEY=YOUR_METAMASK_TESTNET_ACCOUNT_PRIVATE_KEY  # Make sure this account has Sepolia ETH
```

### Step 3: Load Environment Variables

```bash
source .env
```

### Step 4: Deploy to Sepolia

```bash
# Deploy to Sepolia testnet
forge script script/DeploySimpleStorage.s.sol --rpc-url $SEPOLIA_RPC_URL --broadcast --private-key $PRIVATE_KEY
```

### Step 5: Verify Deployment

```bash
# Find the transaction hash from the output, for example:
# Transaction: 0x1234567890abcdef...

# View in browser:
# https://sepolia.etherscan.io/tx/YOUR_TRANSACTION_HASH
```

---

## 📚 Common Commands Quick Reference

| Command | Purpose | Example |
|------|------|------|
| `anvil` | Start local testnet | `anvil` |
| `forge build` | Compile contract | `forge build` |
| `forge create` | Direct deployment | `forge create SimpleStorage --interactive` |
| `forge script` | Script deployment | `forge script script/DeploySimpleStorage.s.sol --broadcast` |
| `cast send` | Send transaction | `cast send $ADDRESS "store(uint256)" 42` |
| `cast call` | Read data | `cast call $ADDRESS "retrieve()"` |
| `cast --to-base` | Base conversion | `cast --to-base 0x123 dec` |
| `cast wallet import` | Import private key | `cast wallet import myaccount --interactive` |
| `cast wallet list` | View keystore | `cast wallet list` |
| `history -c` | Clear history | `history -c` |

---

## ⚠️ Important Security Reminders

1. **Never** store or use private keys associated with real assets in plain text
2. **Never** write private keys on the command line (they get saved in history)
3. **Never** commit `.env` files containing private keys to GitHub
4. Anvil private keys for local testing are public and should only be used for development
5. Use `--interactive` or keystore methods to input private keys
6. Regularly clear terminal history: `history -c`

---

## ✅ Complete Workflow Example

```bash
# 1. Start Anvil (Terminal 1)
anvil

# 2. Open a new terminal (Terminal 2)
cd your-project

# 3. Compile contract
forge build

# 4. Import private key to keystore (only needed once)
cast wallet import testaccount --interactive

# 5. Deploy contract
forge script script/DeploySimpleStorage.s.sol --rpc-url http://127.0.0.1:8545 --broadcast --account testaccount --sender 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266

# 6. Copy deployed contract address
CONTRACT=0x5fbdb2315678afecb367f032d93f642f64180aa3

# 7. Store data
cast send $CONTRACT "store(uint256)" 42 --rpc-url http://127.0.0.1:8545 --account testaccount

# 8. Read data
cast call $CONTRACT "retrieve()" --rpc-url http://127.0.0.1:8545 | cast --to-dec

# 9. Clear history
history -c
```
