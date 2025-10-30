from fastapi import FastAPI
import socket
from datetime import datetime, timezone

app = FastAPI(title="Simple App", version="1.0.0")

@app.get("/")
def root():
    return {"app": "simple-app", "version": "1.0.0", "host": socket.gethostname()}

@app.get("/healthz")
def healthz():
    return {"status": "ok"}

@app.get("/time")
def time():
    return {"utc": datetime.now(timezone.utc).isoformat()}
