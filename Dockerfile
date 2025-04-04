# Dockerfile
FROM ubuntu:22.04 as base

# 環境変数設定
ARG USER_ID=1000
ARG GROUP_ID=1000
ARG USERNAME=appuser

# タイムゾーンを非対話的に設定
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 基本パッケージのインストール
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    sudo \
    make \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ユーザー作成とsudo権限の付与
RUN groupadd --gid $GROUP_ID $USERNAME \
    && useradd --uid $USER_ID --gid $GROUP_ID --create-home --shell /bin/bash $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# 開発環境
FROM base as development

# 開発用パッケージのインストール
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# appuserに切り替え
USER $USERNAME
WORKDIR /home/$USERNAME/app

# 本番環境
FROM base as production

# 本番用パッケージのインストール
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# appuserに切り替え
USER $USERNAME
WORKDIR /home/$USERNAME/app

CMD ["bash"]