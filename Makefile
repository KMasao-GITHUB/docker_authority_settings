.PHONY: build up down shell restart clean rebuild help

# 環境変数
export USER_ID=$(shell id -u)
export GROUP_ID=$(shell id -g)
export USERNAME=$(shell whoami)

# デフォルトターゲット
.DEFAULT_GOAL := help

# コンテナ内のコマンドを実行
DOCKER_COMPOSE := docker-compose
DOCKER_EXEC := $(DOCKER_COMPOSE) exec app

# 開発環境の構築
build: ## 開発環境のビルド
	$(DOCKER_COMPOSE) build

up: ## 開発環境を起動
	$(DOCKER_COMPOSE) up -d

down: ## 開発環境を停止
	$(DOCKER_COMPOSE) down

shell: ## コンテナ内でシェルを起動
	$(DOCKER_EXEC) bash

restart: down up ## 開発環境を再起動

clean: ## コンテナとイメージを削除
	$(DOCKER_COMPOSE) down --rmi all --volumes --remove-orphans

rebuild: clean build up ## 開発環境を完全に再構築

# 本番用イメージのビルド
build-prod: ## 本番用イメージをビルド
	docker build --target production -t app:production .

# ファイル権限修正
fix-permissions: ## 権限問題を修正
	$(DOCKER_EXEC) sudo chown -R $(USERNAME):$(USERNAME) .

# ヘルプ
help: ## このヘルプを表示
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'