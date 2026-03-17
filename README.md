<div align="center">

<img src="https://skillicons.dev/icons?i=docker,githubactions,bash,linux" />

<br/>

![GitHub last commit](https://img.shields.io/github/last-commit/Tristan-DW/devkit?style=for-the-badge&color=6e40c9)
![GitHub stars](https://img.shields.io/github/stars/Tristan-DW/devkit?style=for-the-badge&color=f0883e)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)
![Shell](https://img.shields.io/badge/Shell-Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-238636?style=for-the-badge)

# devkit

> **Production DevOps toolkit - Docker templates, GitHub Actions workflows, and shell utilities.**

</div>

---

## Overview

**devkit** is a curated collection of Docker Compose templates, reusable GitHub Actions workflows, and shell scripts for common DevOps tasks. Drop these into any project to get production-grade CI/CD, containerization, and automation without starting from scratch.

---

## Contents

<details>
<summary><strong>Docker Templates</strong></summary>

| File | Description |
|---|---|
| `docker/node-api.Dockerfile` | Multi-stage Node.js API image |
| `docker/react-app.Dockerfile` | Multi-stage React app with Nginx |
| `docker/postgres-init/` | PostgreSQL init scripts |
| `docker/compose.dev.yml` | Full dev stack (app + postgres + redis) |
| `docker/compose.prod.yml` | Production-hardened compose |

</details>

<details>
<summary><strong>GitHub Actions Workflows</strong></summary>

| Workflow | Trigger | Description |
|---|---|---|
| `ci.yml` | Push, PR | Lint, test, build |
| `deploy.yml` | Push to main | Build image, push to registry, deploy |
| `release.yml` | Tag push | Auto-generate changelog and GitHub release |
| `dependency-audit.yml` | Weekly | npm audit + Dependabot summary |
| `db-backup.yml` | Daily cron | Dump PostgreSQL to S3 |

</details>

<details>
<summary><strong>Shell Utilities</strong></summary>

| Script | Description |
|---|---|
| `scripts/setup.sh` | Bootstrap dev environment |
| `scripts/deploy.sh` | SSH deploy with zero-downtime swap |
| `scripts/db-backup.sh` | PostgreSQL dump + S3 upload |
| `scripts/ssl-renew.sh` | Certbot renewal + Nginx reload |
| `scripts/cleanup.sh` | Docker prune + log rotation |

</details>

---

## Quick Start

```bash
git clone https://github.com/Tristan-DW/devkit.git
cd devkit

# Copy templates into your project
cp docker/compose.dev.yml /path/to/your/project/
cp .github/workflows/ci.yml /path/to/your/project/.github/workflows/

# Or use the setup script
./scripts/setup.sh
```

---

## Docker: Node.js API

```dockerfile
# Usage: docker build -f docker/node-api.Dockerfile -t my-api .
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM node:20-alpine AS runner
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .
EXPOSE 3000
CMD ["node", "src/server.js"]
```

---

## GitHub Actions: CI Pipeline

```yaml
# .github/workflows/ci.yml
on: [push, pull_request]
jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: '20' }
      - run: npm ci
      - run: npm run lint
      - run: npm test
      - run: npm run build
```

---

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-feature`)
3. Commit your changes (`git commit -m 'Add my feature'`)
4. Push to the branch (`git push origin feature/my-feature`)
5. Open a Pull Request

---

<div align="center">

<sub>Architected by <a href="https://github.com/Tristan-DW">Tristan</a> - Head Architect</sub>

</div>
