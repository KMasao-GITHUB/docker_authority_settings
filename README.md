# Docker 開発環境

このリポジトリには Docker を使用した開発環境の設定が含まれています。ホストとコンテナ間のUID/GID不一致による権限問題を解決し、効率的な開発ワークフローを提供します。

## 特徴

- **UID/GID一致**: ホストとコンテナでのファイル所有権の問題を解決
- **マルチステージビルド**: 開発環境と本番環境を最適化
- **Makeコマンド**: 一般的な操作を簡単に実行
- **効率的なイメージ管理**: 保守性とパフォーマンスを向上

## 前提条件

- Docker
- Docker Compose
- make

## セットアップ

1. リポジトリをクローンします:

```bash
git clone <your-repo-url>
cd <your-repo-directory>
```

2. セットアップスクリプトを実行して環境変数を設定します:

```bash
chmod +x setup.sh
./setup.sh
```

3. 開発環境を構築します:

```bash
make build  # 環境をビルド
make up     # コンテナを起動
```

## 利用方法

### 基本的なコマンド

```bash
make shell          # コンテナ内でシェルを起動
make restart        # 環境を再起動
make clean          # コンテナとイメージを削除
make rebuild        # 環境を完全に再構築
make build-prod     # 本番用イメージをビルド
make fix-permissions # 権限問題を修正
make prune          # 未使用のDockerリソースを削除
make deep-clean     # すべての未使用リソースを削除
```

### 権限問題の修正

コンテナ内で作成したファイルにホストから適切にアクセスできない場合:

```bash
make fix-permissions
```

### すべてのコマンドを表示

```bash
make help
```

## コンテナのメンテナンス

未使用のコンテナやイメージを削除するには:

```bash
make prune      # 基本的なクリーンアップ
make deep-clean # 完全なクリーンアップ（ビルドキャッシュやボリュームを含む）
```

## ファイル構成

- `Dockerfile`: マルチステージビルド（base, development, production）
- `docker-compose.yml`: サービス定義と環境設定
- `Makefile`: 一般的な操作のためのコマンド
- `.env.example`: 環境変数のサンプル
- `setup.sh`: 環境変数を設定するヘルパースクリプト
- `.dockerignore`: ビルドコンテキストから除外するファイル

## カスタマイズ

### 追加サービスの統合

`docker-compose.yml` に新しいサービスを追加できます:

```yaml
services:
  db:
    image: postgres:14
    environment:
      - POSTGRES_PASSWORD=postgres
    volumes:
      - db_data:/var/lib/postgresql/data
```

### 環境別の設定

環境ごとに異なる `.env` ファイルを作成できます:

```bash
cp .env .env.staging
# .env.staging を編集して本番環境の値を設定
```

## トラブルシューティング

### 権限エラー

コンテナ内で作成したファイルの所有権でエラーが発生する場合:

```bash
make fix-permissions
```

### コンテナが起動しない

UID/GID設定を確認します:

```bash
cat .env
# USER_ID と GROUP_ID がホストの id -u と id -g と一致することを確認
```

## ベストプラクティス

- `.dockerignore` を使ってビルドコンテキストを軽量化する
- 定期的に `make prune` で未使用リソースをクリーンアップする
- 開発と本番で異なるターゲットを使用する
- 機密情報は `.env` ファイルを通じて管理し、バージョン管理からは除外する
