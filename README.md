# Harness Template - 驾驭工程

<p align="center">
  <strong>让 AI Agent（Claude Code / Cursor）成为你的可靠开发伙伴</strong>
</p>

<p align="center">
  <a href="./README.en.md">English</a> •
  <a href="#快速开始">快速开始</a> •
  <a href="#核心机制">核心机制</a> •
  <a href="#完整指南">完整指南</a> •
  <a href="#常见问题">常见问题</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/AI-Agent-orange" alt="AI Agent">
  <img src="https://img.shields.io/badge/Claude-Code-blue" alt="Claude Code">
  <img src="https://img.shields.io/badge/Cursor-IDE-green" alt="Cursor">
  <img src="https://img.shields.io/badge/LLM-Workflow-yellow" alt="LLM Workflow">
</p>

---

## 为什么需要 Harness？

用 AI 开发代码时，你是否遇到过这些问题：

| 问题 | 典型场景 |
|------|---------|
| 🤷 **上下文丢失** | 昨天做的功能，今天新开会话完全忘了 |
| 🎯 **完成标准模糊** | Agent 说"做完了"，但根本跑不通 |
| 📝 **规则全靠嘴** | 每次都要提醒"记得写测试""别忘了跑 lint" |
| 🔄 **同时做太多** | 一个会话改了 20 个文件，没有一个能用的 |
| 📉 **质量下滑** | 项目越往后越乱，技术债累积 |

**Harness 就是解决这些问题的工程框架。**

它把"怎么让 AI 好好干活"这件事标准化、文档化、自动化。不是每次口头交代，而是把规则写在文件里，让 AI 每次都能看到、都能遵循。

---

## 这是什么？

Harness Template 是一套**与具体技术栈无关的工程骨架**。无论你用 Node.js、Python、Go 还是其他语言，都可以使用这套框架。

### 设计哲学

```
┌─────────────────────────────────────────────────────────────┐
│                     四个"化"                                │
├─────────────────────────────────────────────────────────────┤
│  规则文档化  →  不要口头交代，写在 CLAUDE.md 里              │
│  任务清单化  →  功能拆成清单，写在 features.json 里          │
│  进度可视化  →  做到哪了看 PROGRESS.md                      │
│  验证自动化  →  对不对跑命令，不是"感觉"                     │
└─────────────────────────────────────────────────────────────┘
```

### 工作原理

```
你的需求
    │
    ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│ 功能清单     │ →  │ AI 开发     │ →  │ 验证通过    │
│ (features)  │     │             │     │ (passing)   │
│             │     │ 一次只做一件 │     │             │
│ • 用户注册   │     │ 做完验证     │     │ 才算完成    │
│ • 用户登录   │     │             │     │             │
│ • 创建任务   │     │             │     │             │
└─────────────┘     └─────────────┘     └─────────────┘
       ↑                                      │
       └────────── 新会话从这里继续 ───────────┘
```

---

## 核心机制

### 1. 功能清单驱动（features.json）

每个功能必须有：

```json
{
  "id": "F01",
  "behavior": "用户可以注册账户",
  "verification": "curl -X POST http://localhost:3000/api/register ...",
  "state": "not_started"
}
```

- **behavior**: 从用户视角描述功能
- **verification**: 可执行的验证命令
- **state**: not_started → active → passing

**WIP=1**: 任何时候只能有一个功能处于 active 状态。

### 2. 三层验证

代码从"写完"到"完成"必须通过三关：

```
Level 1: 静态检查
         make lint && make typecheck
                  ↓
Level 2: 测试验证
         make test
                  ↓
Level 3: 端到端验证
         功能特定的验证命令
                  ↓
         标记为 passing（真正完成）
```

### 3. 会话工作流

**每次会话开始，AI 必须：**
1. 读 `CLAUDE.md` → 了解项目是什么
2. 读 `PROGRESS.md` → 了解现在做到哪
3. 读 `features.json` → 了解还有哪些功能
4. 跑 `make check` → 确认环境正常
5. 从 PROGRESS.md 的"下一步"开始

**每次会话结束，AI 必须：**
1. 更新 `PROGRESS.md` → 记录完成的工作
2. 跑 `make check` → 确认一切正常
3. 跑 `check-clean-state.sh` → 检查无残留
4. `git commit` → 提交所有变更

---

## 快速开始

### 第一步：复制模板

```bash
# 方式 1: 直接下载
git clone https://github.com/CMSKL/harness-template.git my-project
cd my-project
rm -rf .git
git init

# 方式 2: 作为模板使用 (GitHub)
# 点击仓库页面的 "Use this template" 按钮
```

### 第二步：填写核心配置（15 分钟）

**1. CLAUDE.md** - 项目说明书

```markdown
## 项目概览
- **项目名称**: MyTodo
- **项目类型**: Web 后端 API
- **一句话描述**: 一个支持用户注册、登录、管理待办事项的 REST API
- **技术栈**: Node.js 20 + Express + SQLite

## 快速开始
make setup    # 安装依赖
make dev      # 启动开发服务器
make test     # 运行测试
make check    # 完整验证

## 硬约束（不能违反）
1. 所有 API 必须返回 JSON
2. 禁止裸写 SQL，必须使用 ORM
3. 所有路由必须有测试
```

**2. Makefile** - 命令映射

```makefile
setup:
	npm install

dev:
	npm run dev

test:
	npm test

lint:
	npx eslint src/

check: lint test
	@echo "All checks passed"
```

**3. features.json** - 功能清单

```json
{
  "schema_version": "1.0",
  "project": "MyTodo",
  "rules": { "wip_limit": 1 },
  "features": [
    {
      "id": "F01",
      "behavior": "用户可以注册账户",
      "verification": "curl -X POST http://localhost:3000/api/register -d '{"email":"test@test.com","password":"123456"}'",
      "state": "not_started",
      "priority": 1
    }
  ]
}
```

### 第三步：开始使用

对 AI Agent 说：

```
请帮我初始化这个项目，然后实现 F01 功能。

步骤：
1. 读 CLAUDE.md 了解项目
2. 运行 make setup 安装依赖
3. 把 features.json 中 F01 的 state 改为 active
4. 实现注册功能（包括测试）
5. 跑验证命令确认通过
6. 把 F01 的 state 改为 passing
7. 更新 PROGRESS.md
8. git commit
```

---

## 完整指南

详细的使用说明、工作流程图解、故障排查，请查看 [GUIDE.md](./GUIDE.md)。

包括：
- 详细的概念图解
- 完整的工作流程
- 真实项目示例
- 常见问题解答
- 进阶用法

---

## 文件结构

```
harness-template/
│
├── 📋 CLAUDE.md              # AI 的"入职手册"
├── 📊 PROGRESS.md            # 工作进度记录
├── 📝 DECISIONS.md           # 设计决策日志
├── ⭐ features.json          # 功能清单（核心）
├── 🎯 QUALITY.md             # 模块质量评分
├── 🔧 Makefile               # 统一命令入口
├── 📖 GUIDE.md               # 详细使用指南
├── LICENSE                   # MIT 协议
│
├── docs/                     # 专题文档
│   ├── architecture.md       # 架构设计
│   ├── api-patterns.md       # API 规范
│   ├── database-rules.md     # 数据库规则
│   ├── testing-standards.md  # 测试标准（含架构边界检查示例）
│   ├── constraints.md        # 硬约束清单
│   ├── sprint-contract-template.md
│   └── handoff-template.md
│
└── scripts/                  # 自动化脚本
    ├── session-start.sh      # 会话开始流程
    ├── session-end.sh        # 会话结束流程
    └── check-clean-state.sh  # 清洁状态检查（5维度）
```

---

## 使用场景

### 👤 个人开发者
- 让 AI 辅助开发项目
- 新会话能无缝接力
- 保持代码质量不下滑

### 👥 团队协作
- 统一的 AI 开发规范
- 清晰的工作交接
- 一致的质量标准

### 📦 复杂项目
- 大功能拆解成小任务
- 依赖关系管理
- 分多次会话完成

---

## 常见问题

### Q: 这个模板适合什么技术栈？

**A:** 任何技术栈。它是与语言无关的工程框架，只需配置对应的 Makefile 命令即可。

### Q: 我不会写 shell 脚本怎么办？

**A:** 直接问 AI："帮我写一个检查 XX 的脚本"。提供检查规则，AI 会帮你生成。

### Q: 功能粒度怎么把握？

**A:** 
- ✅ 好："用户可以注册"
- ❌ 太大："实现用户系统"
- ❌ 太小："创建 User 模型的 name 字段"

一次会话能完成的大小最合适。

### Q: 怎么判断 Harness 够不够好？

**A:** 开个全新会话，不给任何口头说明，问 AI 五个问题：
1. 这是什么项目？
2. 怎么启动？
3. 怎么验证代码对不对？
4. 现在有哪些功能要做？
5. 下一步该做什么？

全部答对 = 合格。

---

## 演进与贡献

### 当前状态

这是一套**基础骨架**，包含核心机制：
- 功能清单系统
- 三层验证
- 会话工作流
- 质量跟踪

### 持续演进

**这个模板会根据实际踩坑持续优化。**

使用过程中的每一个问题，都会让这套模板变得更好：

1. **记录问题** → 使用模板时遇到的坑
2. **提炼规则** → 把解决方案通用化
3. **更新模板** → 把改进合并进来

### 欢迎贡献

- 提交 Issue 描述你的使用场景和问题
- 分享你的改进方案
- 贡献通用的脚本或配置

---

## 理论基础

这套模板的设计参考了以下工程实践：

- [OpenAI: Harness Engineering](https://openai.com/index/harness-engineering/)
- [Anthropic: Effective Harnesses for Long-Running Agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)

> **核心理念：AI Agent 的表现不取决于模型能力，而取决于工程基础设施。**

---

## License

[MIT](LICENSE) © 2026 CMSKL

---

## 支持这个项目

如果这套模板对你有帮助，请给个 ⭐ Star！

你的支持是我持续优化这套模板的动力。每一个 Star 都意味着多一个人觉得这套框架有价值，也让我更有动力去：

- 根据实际使用反馈持续改进
- 补充更多实用的示例和文档
- 分享在使用中踩过的坑和解决方案

<p align="center">
  <a href="https://github.com/CMSKL/harness-template">
    <img src="https://img.shields.io/github/stars/CMSKL/harness-template" alt="GitHub Stars">
  </a>
</p>

<p align="center">
  <a href="https://github.com/CMSKL/harness-template">
    <img src="https://img.shields.io/badge/-Give%20a%20Star-yellow?style=for-the-badge&logo=github" alt="Give a Star">
  </a>
</p>

---

<p align="center">
  <strong>开始使用 Harness，让 AI 成为你的可靠开发伙伴</strong>
</p>
