FROM python:3.11-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy

# System deps (psycopg needs libpq; build-essential for any C extensions)
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/bin/

# Copy dependency files first (better layer caching)
COPY pyproject.toml uv.lock ./

# Install dependencies (no dev deps, frozen to lockfile)
RUN uv sync --frozen --no-install-project --no-dev

# Copy the rest of the project
COPY . .

# Install the project itself
RUN uv sync --frozen --no-dev

# Make sure venv is on PATH
ENV PATH="/app/.venv/bin:$PATH"

EXPOSE 8000

WORKDIR /app/src/multi_agent_travel

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]