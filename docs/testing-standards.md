# testing-standards.md

> 定义测试层级、完成标准和错误消息设计原则。

## 测试层级

1. **静态检查**：lint / typecheck
2. **单元测试**：函数、类、局部逻辑
3. **集成测试**：跨模块协作
4. **端到端测试**：关键用户流程

## 完成定义

- 涉及单模块修改：至少静态检查 + 单元测试通过
- 涉及跨模块修改：至少静态检查 + 集成测试通过
- 涉及关键流程修改：必须有端到端验证

## 测试设计原则

- 测行为，不测实现细节
- 优先测关键路径
- 给 agent 的失败信息必须包含修复方向

## 面向 agent 的错误消息模板

```text
ERROR: <出了什么问题>
WHY: <为什么这算错误>
FIX: <建议如何修改>
```

### 示例

```text
ERROR: Direct filesystem access in src/renderer/App.tsx:12
WHY: Renderer process has no access to Node.js APIs for security
FIX: Move file operations to src/preload/file-ops.ts and call via window.api.readFile()
```

---

## 架构边界执行规则

### 什么是架构边界执行

架构边界执行 = 把架构文档里的规则（如"渲染进程不能直接访问文件系统"）变成**可执行的自动化检查**。

### 为什么需要架构边界执行

单元测试的设计哲学是隔离——模拟依赖，专注被测单元。这个哲学使单元测试快速且精确，但也制造了**系统性的盲区**:

**接口不匹配**：渲染进程传给预加载脚本的文件路径是相对路径，但预加载脚本期望绝对路径。各自的单元测试都用了 mock，都通过了。只有端到端跑通时才发现问题。

**状态传播错误**：数据库迁移改了表结构，但 ORM 的缓存层还持有旧结构的缓存条目。单元测试每次都是全新的 mock 环境，不会暴露这种跨层状态不一致。

**资源生命周期问题**：文件句柄、数据库连接、网络套接字的获取和释放跨越多个组件。单元测试为每个测试创建和销毁独立资源，不会暴露资源竞争或泄漏。

**环境依赖性**：代码在测试环境（一切 mock）行为正确，在真实环境因配置差异、网络延迟、服务不可用而失败。

### 架构边界执行示例

#### 示例 1: Electron 渲染进程隔离

```bash
#!/bin/bash
# scripts/check-renderer-boundary.sh

# 检查渲染进程是否直接调用 Node.js API
if grep -r "require('fs')\|require('path')\|require('os')" src/renderer/ 2>/dev/null; then
  echo "ERROR: Found direct Node.js API import in renderer process"
  echo "WHY: Renderer process has no access to Node.js APIs for security reasons"
  echo "FIX: Move file operations to src/preload/ and expose via contextBridge"
  exit 1
fi
```

#### 示例 2: 分层领域架构依赖检查

```bash
#!/bin/bash
# scripts/check-layer-dependencies.sh

# 架构规则: 依赖方向必须严格向前
# Types -> Config -> Repo -> Service -> Runtime -> UI

# 禁止的反向依赖示例
VIOLATIONS=$(grep -r "from.*Runtime.*import.*Service\|from.*UI.*import.*Runtime" src/ 2>/dev/null || true)

if [ -n "$VIOLATIONS" ]; then
  echo "ERROR: Architecture layer violation detected"
  echo "WHY: Dependencies must flow strictly forward: Types -> Config -> Repo -> Service -> Runtime -> UI"
  echo "FIX: Move the dependent code to the correct layer or refactor to use dependency injection"
  echo "Violations found:"
  echo "$VIOLATIONS"
  exit 1
fi
```

#### 示例 3: 数据库直接访问检查

```bash
#!/bin/bash
# scripts/check-db-access-boundary.sh

# 架构规则: 只有 Repository 层可以直接访问数据库

if grep -r "prisma\|knex\|mongoose" src/api/ src/services/ --include="*.ts" 2>/dev/null | grep -v "import.*from.*types"; then
  echo "ERROR: Database client found outside Repository layer"
  echo "WHY: Only Repository layer should have direct database access"
  echo "FIX: Move database operations to src/repository/ and inject repository into services"
  exit 1
fi
```

#### 示例 4: 前端直接调用后端 API 检查

```bash
#!/bin/bash
# scripts/check-api-client-usage.sh

# 架构规则: 组件必须通过 apiClient 调用后端，禁止直接使用 fetch/axios

if grep -r "fetch\|axios" src/components/ --include="*.tsx" 2>/dev/null | grep -v "// @allowed"; then
  echo "ERROR: Direct HTTP client usage in component layer"
  echo "WHY: All API calls must go through apiClient for consistent error handling, auth, and logging"
  echo "FIX: Import and use the apiClient from src/api/client.ts instead of direct fetch/axios"
  exit 1
fi
```

### 集成到验证流程

```makefile
# Makefile

arch-check:
	@echo "Checking architecture boundaries..."
	bash scripts/check-renderer-boundary.sh
	bash scripts/check-layer-dependencies.sh
	bash scripts/check-db-access-boundary.sh

check: lint typecheck test arch-check
	@echo "All checks passed"
```

### 审查反馈提升流程

把重复出现的架构违规转化为自动化检查：

1. **识别重复问题**：代码审查中重复出现的架构违规类型
2. **转化为检查**：把规则写成可执行脚本（grep、AST 模式、运行时断言）
3. **编写错误消息**：包含 ERROR/WHY/FIX 三要素
4. **集成到 harness**：添加到 Makefile 的 check 目标
5. **验证有效性**：用基准任务验证检查能捕获目标违规

**示例演进**：

```
第 1 周：人工审查发现"渲染进程直接调用 fs"
第 2 周：人工审查再次发现同样问题
第 3 周：编写 scripts/check-renderer-boundary.sh
第 4 周：集成到 make check，问题不再出现
```

每捕获一个违规类别，就增加一条永久的防线。Harness 随时间自动强化。

---

## 端到端测试的不可替代性

### 组件边界缺陷的系统性盲区

| 缺陷类型 | 描述 | 单元测试 | 端到端测试 |
|----------|------|----------|-----------|
| 接口不匹配 | 文件路径格式不一致 | ❌ 未检测 | ✅ 检测 |
| 状态传播 | 导出进度未通过 IPC 传回 UI | ❌ 未检测 | ✅ 检测 |
| 资源泄漏 | 大文件导出句柄未释放 | ❌ 未检测 | ✅ 检测 |
| 权限问题 | 打包环境权限不同 | ❌ 未检测 | ✅ 检测 |
| 错误传播 | 服务层异常未到 UI 层 | ❌ 未检测 | ✅ 检测 |

### 端到端测试改变 agent 行为

当 agent 知道工作要过端到端测试时：

1. **考虑组件交互**：写代码时会想"这个接口和上游怎么对接"
2. **尊重架构边界**：有架构约束的系统里，端到端测试迫使 agent 遵守边界规则
3. **处理错误路径**：端到端测试通常包含故障场景，迫使 agent 考虑异常处理

### 三层验证层级

```
Level 1: 语法与静态分析
  └─ 成本最低，信息量最小，但必须通过

Level 2: 运行时行为验证
  └─ 测试执行、应用启动检查、关键路径验证
  └─ 核心完成证据

Level 3: 系统级确认
  └─ 端到端测试、集成验证、用户场景模拟
  └─ 防止过早声明的最后一道防线
```

**规则：** L1 未通过时，不许进入 L2；L2 未通过时，不许进入 L3。
