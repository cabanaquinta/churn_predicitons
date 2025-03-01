FROM python:3.10-slim

# Install system dependencies needed for Poetry and Python packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gcc curl && \
    rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN pip install poetry==1.8.3

# Set environment variables for Poetry
ENV POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_VIRTUALENVS_CREATE=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache

# Set working directory
WORKDIR /app

# Copy dependency files first for better caching
COPY pyproject.toml poetry.lock ./

# Install dependencies without installing the project itself
RUN poetry install --no-root # instructs Poetry to avoid installing the current project into the virtual environment

# Copy the entire project
COPY web_service.py model_C-1.0.bin ./

# Install the project itself (if needed)
RUN poetry install  # Add flags for better debugging

EXPOSE 9696  

ENTRYPOINT ["poetry", "run", "gunicorn", "--bind", "0.0.0.0:9696", "web_service:app"]

