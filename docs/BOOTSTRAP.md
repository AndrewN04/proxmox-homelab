# Bootstrap (clone → /opt/homelab)

On each VM:
```bash
sudo apt update
sudo apt -y install git
sudo mkdir -p /opt/homelab
sudo chown -R $USER:$USER /opt/homelab
cd /opt
git clone <YOUR_GITHUB_REPO_URL> homelab
```

Fill env files:
```bash
cd /opt/homelab/stacks/infra
cp .env.example .env
chmod 600 .env
```

Start stacks:
```bash
docker compose --env-file /opt/homelab/stacks/infra/.env -f /opt/homelab/stacks/infra/docker-compose.yml up -d
```
