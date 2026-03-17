<div align="center">

<img src="https://skillicons.dev/icons?i=docker,aws,githubactions,bash,linux,python" />

<br/>

![GitHub last commit](https://img.shields.io/github/last-commit/Tristan-DW/devkit?style=for-the-badge&color=6e40c9)
![GitHub stars](https://img.shields.io/github/stars/Tristan-DW/devkit?style=for-the-badge&color=f0883e)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)
![Shell](https://img.shields.io/badge/Shell-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-238636?style=for-the-badge)

# devkit

> **Production DevOps toolkit - Docker templates, AWS deployment, GitHub Actions, and shell utilities.**

</div>

---

## Overview

**devkit** is a curated collection of Docker Compose templates, AWS deployment scripts, reusable GitHub Actions workflows, and shell utilities for common DevOps operations. Drop these into any project to get production-grade CI/CD, containerization, cloud deployment, and automation without starting from scratch.

---

## Contents

<details>
<summary><strong>Docker Templates</strong></summary>

| File | Description |
|---|---|
| `docker/node-api.Dockerfile` | Multi-stage Node.js API image |
| `docker/php-laravel.Dockerfile` | PHP-FPM + Nginx Laravel image |
| `docker/react-app.Dockerfile` | Multi-stage React app with Nginx |
| `docker/compose.dev.yml` | Full dev stack (app + postgres + redis) |
| `docker/compose.prod.yml` | Production-hardened compose |

</details>

<details>
<summary><strong>AWS Scripts</strong></summary>

| Script | Description |
|---|---|
| `aws/deploy-ec2.sh` | Deploy Docker app to EC2 via SSM |
| `aws/s3-backup.sh` | Database dump to S3 with lifecycle tags |
| `aws/cloudfront-invalidate.sh` | Invalidate CloudFront distribution cache |
| `aws/rds-snapshot.sh` | Trigger manual RDS snapshot |
| `aws/ecr-push.sh` | Build, tag, and push image to ECR |

</details>

<details>
<summary><strong>GitHub Actions Workflows</strong></summary>

| Workflow | Trigger | Description |
|---|---|---|
| `ci.yml` | Push, PR | Lint, test, build |
| `deploy-aws.yml` | Push to main | Build, push to ECR, deploy to ECS |
| `release.yml` | Tag push | Auto-generate changelog and release |
| `db-backup.yml` | Daily cron | Dump database to S3 |
| `dependency-audit.yml` | Weekly | npm/composer audit |

</details>

<details>
<summary><strong>Shell Utilities</strong></summary>

| Script | Description |
|---|---|
| `scripts/setup.sh` | Bootstrap local dev environment |
| `scripts/deploy.sh` | SSH deploy with zero-downtime swap |
| `scripts/db-backup.sh` | PostgreSQL/MySQL dump + S3 upload |
| `scripts/ssl-renew.sh` | Certbot renewal + Nginx reload |
| `scripts/cleanup.sh` | Docker prune + log rotation |

</details>

---

## Quick Start

```bash
git clone https://github.com/Tristan-DW/devkit.git

# Copy a template into your project
cp devkit/docker/compose.dev.yml ./docker-compose.yml
cp devkit/.github/workflows/ci.yml .github/workflows/

# Or run setup
./devkit/scripts/setup.sh
```

---

## AWS: Deploy to ECS

```yaml
# .github/workflows/deploy-aws.yml
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: af-south-1
      - name: Login to ECR
        run: aws ecr get-login-password | docker login --username AWS --password-stdin $ECR_REGISTRY
      - name: Build and push
        run: |
          docker build -t $ECR_REGISTRY/$IMAGE_NAME:$GITHUB_SHA .
          docker push $ECR_REGISTRY/$IMAGE_NAME:$GITHUB_SHA
      - name: Deploy to ECS
        run: aws ecs update-service --cluster prod --service api --force-new-deployment
```

---

## Docker: Laravel + PHP-FPM

```dockerfile
FROM php:8.2-fpm-alpine AS base
RUN docker-php-ext-install pdo pdo_mysql redis opcache

FROM base AS deps
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader

FROM base AS runner
COPY --from=deps /app/vendor ./vendor
COPY . .
RUN php artisan config:cache && php artisan route:cache
EXPOSE 9000
CMD ["php-fpm"]
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
