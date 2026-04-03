setup:
	@echo "TODO: 安装依赖，例如 npm install / uv sync / pip install -r requirements.txt"

dev:
	@echo "TODO: 启动开发服务器"

test:
	@echo "TODO: 运行测试"

typecheck:
	@echo "TODO: 运行类型检查"

lint:
	@echo "TODO: 运行 lint"

build:
	@echo "TODO: 运行构建"

check: test typecheck lint build
	@echo "All checks passed"

session-start:
	bash scripts/session-start.sh

session-end:
	bash scripts/session-end.sh
