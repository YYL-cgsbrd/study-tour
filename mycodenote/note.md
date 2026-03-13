```markdown
# 📤 GitHub 上传指南（VS Code + 网页版双教程）

---

## 第一部分：准备工作

### 1.1 注册GitHub账号

如果你还没有GitHub账号：

1. 打开浏览器，访问 [GitHub.com](https://github.com)
2. 点击右上角绿色的 **“Sign up”** 按钮
3. 按提示填写：
   - 邮箱地址
   - 密码（至少8位，要包含字母和数字）
   - 用户名（例如：`yourname123`）
   - 完成邮箱验证（去你的邮箱点确认链接）

---

### 1.2 安装Git（如果要用VS Code命令行）

**Windows用户：**

1. 访问 [git-scm.com](https://git-scm.com/download/win)
2. 下载安装包，一路点击“下一步”完成安装
3. 安装完成后，打开VS Code的终端（Terminal），输入：
   ```bash
   git --version
   ```
   如果显示类似 `git version 2.43.0`，说明安装成功

**Mac用户：**

1. 打开终端（Terminal）
2. 输入 `git --version`
3. 如果没安装，系统会提示安装，点击确认即可

---

### 1.3 配置.gitignore文件（非常重要！）

在项目根目录创建一个名为 `.gitignore` 的文件（注意前面有个点），把以下内容复制进去：

```gitignore
# 编译文件
cache/
out/
node_modules/

# 环境变量文件（绝对不能上传！）
.env
.env.local
.env.production

# 私钥文件
.keystore
*.pem
*.key

# 部署记录（可选）
broadcast/
!/broadcast
/broadcast/*/31337/
/broadcast/**/dry-run/

# 系统文件
.DS_Store
Thumbs.db

# 依赖库（通常不需要上传）
lib/
```

**为什么要配置这个？**

- 防止把密码、私钥传到网上
- 减少上传文件数量，加快上传速度
- 避免上传临时文件、编译文件等不需要分享的内容

---

## 第二部分：方法一（网页版拖拽上传）—— 最简单，适合小白

### 2.1 创建新仓库

1. 登录 [GitHub.com](https://github.com)
2. 点击右上角的 **“+”** 图标 → **“New repository”**

   ```
   [截图示意位置]
   ┌─────────────────┐
   │   +  New        │
   │     New repository
   │     Import repository
   │     New codespace
   └─────────────────┘
   ```

3. 填写仓库信息：

   ```
   Repository name: my-first-project    ← 给你的项目起个名字
   Description: 这是我的第一个项目       ← 可写可不写
   
   Public / Private: ● Private          ← 选Private（私有，只有你能看）
   
   Initialize this repository with:     
   □ Add a README file                   ← ⚠️ 不要勾选！
   □ Add .gitignore                      ← ⚠️ 不要勾选！
   □ Choose a license                     ← ⚠️ 不要勾选！
   ```

4. 点击底部绿色的 **“Create repository”**

---

### 2.2 进入上传页面

创建成功后，你会看到一个空仓库页面。找到蓝色的 **“uploading an existing file”** 链接并点击它。

---

### 2.3 拖拽文件

1. **在电脑上打开你的项目文件夹**
   - 找到存放你代码的文件夹
   - 把文件夹窗口打开，放在屏幕一边

2. **选中所有要上传的文件**
   - 按 `Ctrl+A`（Mac按 `Command+A`）全选所有文件
   - 或者按住 `Ctrl` 键一个个选择

3. **拖拽到浏览器**
   - 用鼠标按住选中的文件（不要松手）
   - 拖到浏览器的虚线框区域
   - 看到“Drop to upload”提示时，松开鼠标

---

### 2.4 提交上传

1. **滚动到页面底部**
2. **填写提交信息**：

   ```
   Commit message
   [第一次上传项目文件]                ← 必须写，简单说明这次上传了什么
   
   Extended description (optional)
   [上传了所有合约文件和测试文件]       ← 可写可不写
   ```

3. **确认提交选项**
   - 确保选中 **“Commit directly to the main branch”**

4. **点击绿色的 “Commit changes” 按钮**

---

### 2.5 验证上传成功

页面刷新后，你应该能看到文件列表：

```
my-first-project/
├── src/
├── test/
├── script/
├── README.md
├── foundry.toml
└── ...（其他文件）
```

点击任意文件查看内容是否正确。

---

## 第三部分：方法二（VS Code 命令行上传）—— 更专业，适合经常更新

### 3.1 在VS Code中打开项目

1. 打开 VS Code
2. 点击 **“File”** → **“Open Folder”**
3. 选择你的项目文件夹
4. 点击 **“Open”**

---

### 3.2 打开终端

在VS Code中，按 **`` Ctrl + ` ``**（键盘上1左边的那个键），或者点击顶部菜单 **“Terminal”** → **“New Terminal”**

---

### 3.3 检查Git状态

在终端输入：

```bash
git status
```

如果看到：

```
fatal: not a git repository
```

说明还没初始化Git，继续下一步。

如果看到文件列表，说明已经是Git仓库了。

---

### 3.4 初始化Git仓库

```bash
git init -b main
```

会看到：

```
Initialized empty Git repository in /你的路径/.git/
```

---

### 3.5 添加文件到暂存区

```bash
git add .
```

这行命令的意思：把所有文件添加到待提交列表

---

### 3.6 检查哪些文件会被提交

再次运行：

```bash
git status
```

你会看到绿色的文件列表，这些都是准备提交的。**仔细检查有没有 `.env` 文件！**如果有，说明你的 `.gitignore` 没配置好，先按第一部分配置好再继续。

---

### 3.7 提交文件

```bash
git commit -m "第一次提交：上传项目文件"
```

`-m` 后面引号里的内容就是提交说明，可以改成你想说的话。

---

### 3.8 创建GitHub仓库（同方法一的2.1）

按照 **第二部分 2.1** 的步骤在GitHub上创建新仓库。

---

### 3.9 关联远程仓库

创建好仓库后，GitHub会显示一个页面，找到 **“…or push an existing repository from the command line”** 部分，复制这两行命令（你的链接会不一样）：

```bash
git remote add origin https://github.com/你的用户名/你的仓库名.git
git branch -M main
```

在VS Code终端里粘贴并运行这些命令。

---

### 3.10 推送到GitHub

```bash
git push -u origin main
```

**第一次推送时，可能会弹出登录窗口：**

- 选择 **“Sign in with your browser”**
- 浏览器会自动打开GitHub登录页
- 登录后授权即可

推送成功后，会看到类似：

```
Enumerating objects: 25, done.
Counting objects: 100% (25/25), done.
Writing objects: 100% (25/25), 45.67 KiB | done.
Total 25 (delta 0), reused 0 (delta 0)
To https://github.com/你的用户名/你的仓库名.git
 * [new branch]      main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.
```

---

### 3.11 验证上传

回到GitHub网页，刷新仓库页面，你的文件应该都在了！

---

## 第四部分：后续更新代码

### 4.1 网页版更新

1. 在仓库页面点击 **“Add file”** → **“Upload files”**
2. 拖拽更新后的文件
3. 填写提交说明，点击 **“Commit changes”**

---

### 4.2 VS Code命令行更新

每次修改代码后，按顺序执行这三条命令：

```bash
# 1. 查看修改了哪些文件
git status

# 2. 添加所有修改的文件
git add .

# 3. 提交修改
git commit -m "更新了XXX功能"

# 4. 推送到GitHub
git push
```

---

### 4.3 删除文件（网页版）

1. 进入文件所在文件夹
2. 勾选要删除的文件
3. 点击右上角 **“…”** → **“Delete”**
4. 提交更改

---

### 4.4 删除文件（VS Code命令行）

```bash
# 删除文件（例如：删除旧的README.md）
git rm README.md

# 提交删除
git commit -m "删除了旧文件"

# 推送到GitHub
git push
```

---

## 第五部分：常用命令速查表

| 操作 | 命令 |
| :--- | :--- |
| 查看当前状态 | `git status` |
| 添加所有文件 | `git add .` |
| 添加单个文件 | `git add 文件名` |
| 提交 | `git commit -m “说明”` |
| 推送到GitHub | `git push` |
| 查看提交历史 | `git log` |
| 下载别人的项目 | `git clone 仓库地址` |

---

## 第六部分：常见问题解答

### Q1：上传时提示文件太大怎么办？

**错误信息：** “File XXX is 125.34 MB; this exceeds GitHub‘s file size limit of 100 MB”

**解决方法：**

1. **压缩文件**：用WinRAR或7-Zip把大文件压缩成.zip
2. **使用Git LFS**（大文件存储）：
   ```bash
   git lfs track “*.大型文件后缀”
   git add .gitattributes
   git commit -m “配置LFS”
   ```
3. **排除文件**：在 `.gitignore` 里添加大文件名

---

### Q2：不小心上传了密码/私钥怎么办？

**情况紧急！立即处理：**

1. **删除文件**（用网页版或命令行）
2. **更换密码/私钥**：
   - 去Alchemy重新生成API Key
   - 去MetaMask导出新私钥（注意：如果是主网私钥，立即转移资产！）
3. **清理Git历史**（防止别人从历史记录里找到）：
   ```bash
   # 安装bfg工具
   # 然后用它彻底删除文件历史
   ```

**重要提醒：** 如果上传的是**真实资产私钥**，**第一时间转移资产！** 不要犹豫！

---

### Q3：推送时提示 “remote: Repository not found”

**错误信息：** “remote: Repository not found. fatal: repository ‘https://...’ not found”

**原因：** 仓库地址不对，或者没有权限

**解决方法：**

```bash
# 检查远程地址
git remote -v

# 如果不对，重新设置
git remote remove origin
git remote add origin 正确的仓库地址
```

---

### Q4：推送时提示 “failed to push some refs”

**错误信息：** “Updates were rejected because the remote contains work that you do not have locally”

**原因：** GitHub上已经有文件（比如你网页上传了README），和本地冲突

**解决方法：**

```bash
# 先把远程代码拉下来合并
git pull origin main --allow-unrelated-histories

# 然后再推送
git push origin main
```

---

### Q5：想删除整个仓库

1. 进入仓库页面，点击 **“Settings”**
2. 滚动到最底部 **“Danger Zone”**
3. 点击 **“Delete this repository”**
4. 输入仓库名确认

**注意：** 删除后无法恢复，所有代码都会消失！

---

## 第七部分：分享你的代码

### 7.1 获取仓库链接

1. 在仓库页面点击绿色的 **“Code”** 按钮
2. 复制HTTPS链接（格式：`https://github.com/用户名/仓库名.git`）

### 7.2 让别人下载

别人可以用这个命令下载你的代码：

```bash
git clone https://github.com/用户名/仓库名.git
```

### 7.3 让别人查看（不用下载）

直接把链接发给他们，浏览器打开就能看到所有代码！

---

# 🎉 恭喜！你成功了！

现在你的代码已经安全地保存在GitHub上：

- ✅ 永远不会丢失
- ✅ 可以随时查看历史版本
- ✅ 可以和别人分享
- ✅ 面试时可以展示给面试官

**记住：**

- 第一次操作可能会手忙脚乱，多试几次就熟练了
- 遇到问题先看错误信息，用百度/Google搜索
- 可以截屏发到Cyfrin Discord求助

**快去试试吧！**
```
