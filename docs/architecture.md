# architecture.md

> 描述系统整体架构和模块边界。重点是让 agent 知道“哪些依赖方向是允许的，哪些是不允许的”。

## 系统概览
- TODO: 一句话描述系统架构

## 模块划分
- `src/api/`：TODO
- `src/services/`：TODO
- `src/models/`：TODO
- `src/utils/`：TODO

## 依赖方向
- TODO: 例如 `api -> services -> models`
- TODO: 列出禁止的依赖方向

## 架构边界规则
- TODO: 例如“UI 层不能直接访问数据库”
- TODO: 例如“控制器不写业务逻辑，只做参数解析和响应组装”

## 关键入口
- TODO: 启动入口
- TODO: 请求入口
- TODO: 后台任务入口
