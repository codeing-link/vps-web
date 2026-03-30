# vps-web

一个最小的 Web 项目，页面显示 `Hello`，支持：
- 本地开发后上传到 GitHub
- VPS 上一键拉取并部署

## 1. 项目结构

- `index.html`：页面内容
- `Dockerfile`：Nginx 静态站点镜像
- `docker-compose.yml`：容器编排（80 端口）
- `scripts/deploy_vps.sh`：VPS 一键拉取部署脚本

## 2. 本地初始化并上传 GitHub

在项目根目录执行（与你给的仓库一致）：

```bash
echo "# vps-web" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:codeing-link/vps-web.git
git push -u origin main
```

如果你要把当前全部文件一起提交，建议改为：

```bash
git init
git add .
git commit -m "init: hello web + vps deploy"
git branch -M main
git remote add origin git@github.com:codeing-link/vps-web.git
git push -u origin main
```

## 3. VPS 首次准备（Ubuntu）

```bash
sudo apt update
sudo apt install -y git docker.io docker-compose-plugin
sudo systemctl enable --now docker
```

如果你用 `root` 以外账户部署，可执行：

```bash
sudo usermod -aG docker $USER
# 重新登录后生效
```

## 4. VPS 一键拉取并部署

在 VPS 执行：

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/codeing-link/vps-web/main/scripts/deploy_vps.sh)
```

或先手动下载再执行：

```bash
git clone git@github.com:codeing-link/vps-web.git /opt/vps-web
cd /opt/vps-web
bash scripts/deploy_vps.sh
```

脚本默认参数：
- 仓库：`git@github.com:codeing-link/vps-web.git`
- 部署目录：`/opt/vps-web`
- 分支：`main`

也可以自定义：

```bash
bash scripts/deploy_vps.sh git@github.com:codeing-link/vps-web.git /opt/vps-web main
```

## 5. 更新发布流程

每次本地改完后：

```bash
git add .
git commit -m "feat: update page"
git push
```

然后到 VPS 执行一条命令更新：

```bash
cd /opt/vps-web && bash scripts/deploy_vps.sh
```

## 6. 验证

- 查看容器：

```bash
docker ps
```

- 访问：`http://你的VPS公网IP/`

页面出现 `Hello` 即部署成功。
