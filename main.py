"""
FastAPI Test Application
Production-ready example with Let's Encrypt SSL
"""

from fastapi import FastAPI, HTTPException
from datetime import datetime
import uvicorn
import os

# Application metadata
app = FastAPI(
    title="FastAPI Test Application",
    description="Production-ready FastAPI app with auto-deployment",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
)

# ============================================
# Endpoints
# ============================================

@app.get("/")
async def root():
    """Root endpoint - welcome message"""
    return {
        "message": "🚀 Добро пожаловать в FastAPI с Let's Encrypt!",
        "domain": "prompt-engineer.su",
        "ssl": "Let's Encrypt",
        "status": "production",
        "timestamp": datetime.now().isoformat()
    }

@app.get("/health")
async def health():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "service": "fastapi-test-app",
        "timestamp": datetime.now().isoformat(),
        "version": "1.0.0"
    }

@app.get("/info")
async def info():
    """Application information"""
    return {
        "app_name": "FastAPI Test App",
        "version": "1.0.0",
        "domain": "app.prompt-engineer.su",
        "ssl_provider": "Let's Encrypt",
        "auto_deploy": "Watchtower",
        "reverse_proxy": "Traefik",
        "endpoints": [
            "/",
            "/health",
            "/info",
            "/current-date",
            "/version",
            "/changelog",
            "/docs",
            "/redoc"
        ]
    }

@app.get("/current-date")
async def get_current_date():
    """Get current date and time"""
    now = datetime.now()
    return {
        "current_date": now.strftime("%Y-%m-%d"),
        "current_time": now.strftime("%H:%M:%S"),
        "full_datetime": now.isoformat(),
        "day_of_week": now.strftime("%A"),
        "timezone": "UTC"
    }

@app.get("/version")
async def version():
    """Application version"""
    return {
        "version": "1.0.1",
        "build_date": "2025-10-26",
        "environment": os.getenv("ENVIRONMENT", "production"),
        "auto_updated": True,
        "new_feature": "Multiple versions demo!"
    }

@app.get("/changelog")
async def changelog():
    """Application changelog"""
    return {
        "version": "1.0.1",
        "changes": [
            "Added changelog endpoint",
            "Updated version to 1.0.1",
            "Demonstrated multiple versions in Registry",
            "Enhanced version information"
        ],
        "previous_version": "1.0.0"
    }

@app.get("/test-error")
async def test_error():
    """Test error handling"""
    raise HTTPException(
        status_code=500,
        detail="This is a test error"
    )

# ============================================
# Main
# ============================================

if __name__ == "__main__":
    uvicorn.run(
        app,
        host="0.0.0.0",
        port=8000,
        log_level="info"
    )
