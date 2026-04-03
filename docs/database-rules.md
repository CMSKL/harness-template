# database-rules.md

> 涉及数据库操作、迁移、事务时必读。

## 基本规则
- TODO: 所有 schema 变更必须通过 migration
- TODO: 禁止手动改线上数据库结构
- TODO: 查询/写入优先使用统一的数据访问层

## 事务边界
- TODO: 哪些操作必须放在同一事务里
- TODO: 哪些地方禁止跨事务副作用

## 迁移流程
1. 生成 migration
2. 本地执行 migration
3. 跑测试
4. 验证回滚（如适用）

## 验证要求
- TODO: 新表/新字段必须有对应测试
- TODO: 关键查询必须覆盖边界条件
