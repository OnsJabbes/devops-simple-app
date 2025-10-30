# ---- builder ----
FROM python:3.12-slim AS builder
WORKDIR /wheels
# Faster, quieter pip; no cache kept on disk
ENV PIP_DISABLE_PIP_VERSION_CHECK=1 PIP_NO_CACHE_DIR=1
COPY app/requirements.txt .
# Build wheels for pinned deps (no network needed later)
RUN pip wheel --no-cache-dir --wheel-dir=/wheels -r requirements.txt

# ---- runtime ----
FROM python:3.12-slim
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1
WORKDIR /app

# non-root user
RUN useradd -u 10001 -m appuser

# install from prebuilt wheels (no index/network), then clean up
COPY --from=builder /wheels /wheels
COPY app/requirements.txt .
RUN pip install --no-index --find-links=/wheels -r requirements.txt \
    && rm -rf /wheels requirements.txt

# app code
COPY app /app

EXPOSE 8000
USER appuser
CMD ["python", "-m", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
