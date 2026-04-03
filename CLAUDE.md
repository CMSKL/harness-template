# CLAUDE.md — Agent 入口路由文件

> 本文件是 agent 的"着陆页"。它告诉 agent 这是什么项目、怎么跑、怎么验证、哪些不能做。
> **保持简短（50-200行）**。详细信息去专题文档里找，不要堆在这里。

---

## 项目概览

- **项目名称**：TODO: 填写项目名称
- **项目类型**：TODO: Web 后端 / 前端应用 / CLI 工具 / 微服务 / ...
- **一句话描述**：TODO: 用一句话描述这个系统是做什么的
- **技术栈**：TODO: 列出主要技术栈和版本（如 Python 3.11 / Node 20 / FastAPI 0.100+）
- **代码规模**：TODO: 约 XX 行代码，XX 个模块

---

## 快速开始

```bash
# 安装依赖
make setup

# 运行测试
make test

# 类型检查
make typecheck

# Lint
make lint

# 完整验证（所有以上 + 构建）
make check

# 启动开发服务器
make dev
```

---

## 硬约束（不可违反）

> 以下规则是红线，agent 绝对不能违反。违反直接判定为任务失败。

1. TODO: 列出所有硬约束，例如"所有数据库操作必须用 ORM，不许裸写 SQL"
2. TODO: 例如"所有 API 必须走 OAuth 2.0 认证"
3. TODO: 例如"禁止在代码里硬编码密钥，必须用环境变量"
4. TODO: ...
5. TODO: ...

---

## 项目结构

```
src/              # 源代码
  api/            # API 层
  models/         # 数据模型
  services/       # 业务逻辑
  utils/          # 工具函数
tests/            # 测试文件（与 src/ 结构对应）
docs/             # 专题文档
scripts/          # 运维脚本
```

---

## 专题文档（按需阅读）

| 文档 | 什么时候读 |
|------|-----------|
| [docs/api-patterns.md](docs/api-patterns.md) | 添加或修改 API 端点时 |
| [docs/database-rules.md](docs/database-rules.md) | 涉及数据库操作时 |
| [docs/testing-standards.md](docs/testing-standards.md) | 编写或修改测试时 |
| [docs/architecture.md](docs/architecture.md) | 理解整体架构时 |
| [docs/constraints.md](docs/constraints.md) | 了解所有硬约束时 |

---

## 会话工作流

### 每次会话开始时
1. 读 `PROGRESS.md` 了解当前状态
2. 读 `DECISIONS.md` 了解重要设计决策
3. 读 `features.json` 了解当前功能项状态
4. 跑 `make check` 确认仓库处于一致状态
5. 从 `PROGRESS.md` 的"下一步"部分开始工作

### 每次会话结束前（必须全部执行）
1. 更新 `PROGRESS.md`（记录完成项、当前状态、下一步）
2. 更新 `features.json`（如有功能项状态变更）
3. 跑 `make check` 确认一切正常
4. 确保无临时调试代码残留（console.log、debugger、注释掉的代码）
5. git commit 所有变更

---

## 功能开发规则

- **WIP=1**：任何时刻只允许一个功能项处于"进行中"状态
- **完成定义**：端到端验证通过才算完成，不是"代码写完了"
- **不允许"顺便重构"**：核心功能验证通过之前，不许做重构或优化
- **状态转移**：功能项状态由 `scripts/verify-feature.sh` 自动更新，agent 不能手动改

### 三层验证层级（必须逐层通过）

| 层级 | 验证内容 | 适用场景 | 通过标准 |
|------|----------|----------|----------|
| **L1: 静态检查** | lint、typecheck、格式检查 | 所有修改 | `make lint && make typecheck` 无错误 |
| **L2: 单元/集成测试** | 模块功能、跨模块协作 | 所有修改 | `make test` 全部通过 |
| **L3: 端到端验证** | 完整用户流程、系统行为 | 涉及跨组件或关键流程 | 验证命令执行成功 |

**规则：**
- L1 未通过时，不许进入 L2
- L2 未通过时，不许进入 L3
- 跳过任何必须层级的任务 = 未完成

---

## 启动命令速查

| 操作 | 命令 |
|------|------|
| 安装依赖 | `make setup` |
| 开发模式 | `make dev` |
| 运行测试 | `make test` |
| 完整验证 | `make check` |
| 新增功能项 | `scripts/add-feature.sh <id> "<行为描述>" "<验证命令>"` |
| 更新进度 | `scripts/update-progress.sh` |

---

## 联系方式 / 相关资源

- TODO: 补充相关链接、文档、联系人等
