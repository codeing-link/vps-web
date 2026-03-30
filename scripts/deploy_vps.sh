#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${1:-git@github.com:codeing-link/vps-web.git}"
APP_DIR="${2:-/opt/vps-web}"
BRANCH="${3:-main}"

if ! command -v git >/dev/null 2>&1; then
  echo "[ERROR] git 未安装，请先安装 git"
  exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "[ERROR] docker 未安装，请先安装 docker"
  exit 1
fi

mkdir -p "$(dirname "$APP_DIR")"

if [ ! -d "$APP_DIR/.git" ]; then
  echo "[INFO] 首次部署：克隆仓库到 $APP_DIR"
  git clone "$REPO_URL" "$APP_DIR"
else
  echo "[INFO] 检测到已有仓库，执行拉取更新"
fi

cd "$APP_DIR"

echo "[INFO] 切换并更新分支：$BRANCH"
git fetch origin "$BRANCH"
git checkout "$BRANCH"
git pull origin "$BRANCH"

echo "[INFO] 重新构建并启动容器"
docker compose up -d --build

echo "[OK] 部署完成，访问: http://$(hostname -I | awk '{print $1}')/"
