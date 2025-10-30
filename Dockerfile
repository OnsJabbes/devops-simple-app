# ---- builder ----
FROM python:3.12-slim AS builder
WORKDIR /wheels
ENV PIP_DISABLE_PIP_VERSION_CHECK=1 PIP_NO_CACHE_DIR=1
RUN apt-get update && apt-get install -y --no-install-recommends build-essential && rm -rf /var/lib/apt/lists/*
COPY app/requirements.txt .
RUN pip wheel --wheel-dir=/wheels -r requirements.txt

# ---- runtime ----
FROM python:3.12-slim
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1
WORKDIR /app
RUN useradd -u 10001 -m appuser
COPY --from=builder /wheels /wheels
RUN pip install --no-index --find-links=/wheels fastapi uvicorn[standard] && rm -rf /wheels
COPY app /app
EXPOSE 8000
USER appuser
CMD ["python", "-m", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
