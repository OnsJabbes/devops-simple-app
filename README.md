![CI](https://github.com/OnsJabbes/devops-simple-app/actions/workflows/ci.yml/badge.svg)

# Simple DevOps App 

A tiny FastAPI app with:
- **Multi-stage Dockerfile**
- **docker-compose** for local runs
- **Docker Swarm** stack for simple orchestration
- **GitHub Actions CI** (ruff, flake8, hadolint, build)

## Run (Compose)
```bash
docker compose up --build
# http://localhost:8000/  and  http://localhost:8000/healthz
```

## Orchestrate (Swarm)
```bash
docker swarm init
docker stack deploy -c swarm/stack.yml simple-app
docker stack services simple-app
# http://localhost:8000/
```

## CI
On push, the workflow lints Python (ruff, flake8), lints Dockerfile (hadolint), then builds the image.

## Endpoints
- `GET /`       → app info (name, version, hostname)
- `GET /healthz`→ status ok (for probes)
- `GET /time`   → current UTC timestamp

## 🧭 Architecture Overview
      ┌────────────────────┐
      │    Developer       │
      │ (pushes to GitHub) │
      └─────────┬──────────┘
                │
                ▼
      ┌────────────────────┐
      │ GitHub Actions CI  │
      │ - Lint (Ruff, Flake8, Hadolint)
      │ - Build Docker image
      └─────────┬──────────┘
                │
                ▼
      ┌────────────────────┐
      │     Docker Image   │
      │ (multi-stage build)│
      └─────────┬──────────┘
                │
                ▼
      ┌────────────────────┐
      │   Docker Swarm     │
      │ - 2 replicas       │
      │ - Rolling updates  │
      └─────────┬──────────┘
                │
                ▼
      ┌────────────────────┐
      │    User Browser    │
      │ http://localhost:8000 │
      └────────────────────┘

---

## 🧱 Dockerfile Explanation

### **Stage 1 – Builder**
- Based on `python:3.12-slim`
- Installs build tools and compiles dependencies into **Python wheels**
- Caches dependencies for faster builds

### **Stage 2 – Runtime**
- Also based on `python:3.12-slim`

runs the FastAPI app securely with only what’s needed — resulting in a clean, fast, and production-grade container.
---

## 🚀 Run Locally (Docker Compose)

```bash
docker compose up --build


