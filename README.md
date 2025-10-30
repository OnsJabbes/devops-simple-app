# Simple DevOps App (Minimal)

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
On push/PR, the workflow lints Python (ruff, flake8), lints Dockerfile (hadolint), then builds the image.

## Endpoints
- `GET /`       → app info (name, version, hostname)
- `GET /healthz`→ status ok (for probes)
- `GET /time`   → current UTC timestamp

## Submit
1. Create a GitHub repo (e.g., `devops-simple-app-<yourname>`)
2. Push this project
3. Share the repo URL
