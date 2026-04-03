# Harness Template

> 一套让 AI Agent 能够稳定、可靠地帮你开发项目的工程框架

---

## 这是什么？

Harness Template 是一套**通用的工程骨架**，它不是针对特定技术栈的代码模板，而是一套**工作规范 + 工具包**。

### 核心思想

把你要交代给 AI Agent 的事情**写下来、标准化、可验证**：

- **规则文档化** → 不要每次口头交代，写在文件里
- **任务清单化** → 每个功能有明确的完成标准
- **进度可视化** → 新会话能立刻知道现状
- **验证自动化** → 代码对不对，跑命令就知道

### 一个具体例子

假设你要让 AI 帮你开发一个项目：

| 场景 | 没有 Harness | 有了 Harness |
|------|-------------|-------------|
| 项目是什么 | 解释 10 分钟 | 看 `CLAUDE.md` 30 秒 |
| 做到哪了 | 翻聊天记录 | 看 `PROGRESS.md` |
| 怎么算做完 | "感觉做完了" | 验证命令通过才算 |
| 新会话接力 | 重新开始解释 | 读文件立刻知道 |
| 代码质量 | 越来越乱 | `QUALITY.md` 持续跟踪 |

---

## 包含什么？

```
harness-template/
│
├── 📋 CLAUDE.md              # Agent 的"入职手册"
├── 📊 PROGRESS.md            # 工作进度记录
├── 📝 DECISIONS.md           # 设计决策日志
├── ⭐ features.json          # 功能清单（核心）
├── 🎯 QUALITY.md             # 质量评分表
├── 🔧 Makefile               # 统一操作入口
├── 📖 GUIDE.md               # 详细使用指南
│
├── docs/                     # 专题规则文档
│   ├── architecture.md       # 架构设计
│   ├── api-patterns.md       # API 规范
│   ├── database-rules.md     # 数据库规则
│   ├── testing-standards.md  # 测试标准
│   ├── constraints.md        # 硬约束清单
│   ├── sprint-contract-template.md  # 任务模板
│   └── handoff-template.md   # 交接模板
│
└── scripts/                  # 自动化脚本
    ├── session-start.sh      # 会话开始流程
    ├── session-end.sh        # 会话结束流程
    └── check-clean-state.sh  # 清洁状态检查
```

### 核心机制

1. **三层验证** - 代码从写完到完成必须过三关：
   - L1: 静态检查（lint + typecheck）
   - L2: 单元/集成测试
   - L3: 端到端验证

2. **功能清单驱动** - `features.json` 定义所有功能：
   - 每个功能有明确的行为描述
   - 每个功能有可执行的验证命令
   - 状态机管理：not_started → active → passing
   - WIP=1：一次只做一件事

3. **会话工作流** - 固定的开始/结束动作：
   - 开始：读文档 → 了解状态 → 确认环境
   - 结束：更新进度 → 跑验证 → 提交代码

---

## 快速开始

### 1. 复制模板

```bash
git clone https://github.com/your-repo/harness-template.git my-project
cd my-project
rm -rf .git  # 如果是新项目
git init
```

### 2. 填写核心信息（30 分钟）

**CLAUDE.md** - 项目基本信息：
```markdown
## 项目概览
- **项目名称**：MyProject
- **项目类型**：Web 后端 API
- **一句话描述**：一个支持 XX 功能的 REST API
- **技术栈**：Node.js + Express + PostgreSQL
- **代码规模**：约 X 行，X 个模块

## 快速开始
make setup    # 安装依赖
make dev      # 启动开发
make test     # 运行测试
make check    # 完整验证

## 硬约束（不能违反）
1. 所有 API 必须返回 JSON
2. 禁止裸写 SQL，必须用 ORM
3. 所有路由必须有测试
```

**Makefile** - 你的真实命令：
```makefile
setup:
	npm install

test:
	npm test

lint:
	npx eslint src/

check: lint test
	@echo "All checks passed"
```

**features.json** - 3-5 个初始功能：
```json
{
  "features": [
    {
      "id": "F01",
      "behavior": "用户可以注册账户",
      "verification": "curl -X POST /api/register ...",
      "state": "not_started"
    }
  ]
}
```

### 3. 开始使用

对 AI Agent 说：

> 请帮我初始化这个项目，然后实现 F01 功能。
>
> 步骤：
> 1. 读 CLAUDE.md 了解项目
> 2. 初始化项目环境（make setup）
> 3. 把 F01 状态改为 active
> 4. 实现功能并通过验证
> 5. 更新 PROGRESS.md
> 6. 提交代码

详细步骤见 [GUIDE.md](./GUIDE.md)

---

## 使用场景

### 场景 1：个人项目开发

一个人用 AI 辅助开发项目，需要：
- 新会话能接住上次的工作
- 功能开发有明确的完成标准
- 代码质量不随时间下降

**用法**：按模板初始化 → 定义功能清单 → 逐个功能开发

### 场景 2：团队协作

多人轮流使用 AI Agent 开发同一项目，需要：
- 统一的开发规范
- 清晰的工作交接
- 一致的质量标准

**用法**：共享 Harness 配置 → 各自按流程开发 → 定期回顾 QUALITY.md

### 场景 3：复杂功能拆解

大功能需要拆成多个小功能，分多次会话完成，需要：
- 任务分解和依赖管理
- 进度跟踪
- 部分完成的交接

**用法**：大功能拆成多个 FXX → 标记依赖关系 → 逐个完成

---

## 核心理念

### 1. 写下来，不要口头交代

❌ "记得每次都要跑测试"
✅ `CLAUDE.md` 里写："所有功能必须通过三层验证"

### 2. 能验证，不要靠感觉

❌ "感觉做完了"
✅ `features.json` 里写验证命令，跑通才算完

### 3. 可追溯，不要靠记忆

❌ "上次做到哪了来着？"
✅ `PROGRESS.md` 记录完整进度

### 4. 单向完成，不要来回改

❌ "先做一遍，后面再改"
✅ WIP=1，验证通过才能标记完成

---

## 为什么这样设计？

这套模板基于 [Harness Engineering](https://openai.com/index/harness-engineering/) 的理念设计，核心理念是：

> **AI Agent 的表现不取决于模型能力，而取决于工程基础设施。**

同样的模型，在不同的 Harness 下表现可以有数量级的差异。

具体设计原则参考课程文档（详见后文"学习资源"）。

---

## 演进路线

### 当前状态

这是一套**基础骨架**，包含了核心的：
- 功能清单系统（features.json）
- 三层验证机制
- 会话工作流
- 质量跟踪

### 未来演进

**这个模板会根据实际踩坑持续优化。**

我们会：

1. **记录真实问题** - 使用这套模板时遇到的坑
2. **提炼通用规则** - 把解决方案变成模板的一部分
3. **定期更新发布** - 把经过验证的改进合并进来

### 欢迎贡献踩坑记录

如果你在使用这套模板时遇到问题，或者有改进建议：

- 提交 Issue 描述你遇到的场景
- 分享你的解决方案
- 贡献通用的脚本或配置

**每一个真实的踩坑，都会让这套模板变得更好。**

---

## 学习资源

### 理论基础

这套模板基于以下工程实践设计：

- [OpenAI: Harness Engineering](https://openai.com/index/harness-engineering/)
- [Anthropic: Effective Harnesses for Long-Running Agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)

### 配套课程

本模板配套有完整的 Harness Engineering 课程：

1. **什么是 Harness** - 核心概念和五元组
2. **仓库即规范** - 为什么所有信息必须在仓库里
3. **指令拆分** - 为什么不要把所有规则塞进一个文件
4. **跨会话连续** - 如何让新会话接住上次工作
5. **初始化阶段** - 为什么先搭环境再写功能
6. **任务边界** - WIP=1 和完成功能的证据
7. **防止提前完成** - 三层验证的重要性
8. **端到端测试** - 为什么单元测试不够
9. **可观测性** - 冲刺合同和评分标准
10. **清洁状态** - 每次会话结束的标准动作

课程文档位置：`docs/lectures/`

---

## 许可

MIT License

---

**开始使用 Harness，让 AI Agent 成为真正可靠的开发伙伴。**
