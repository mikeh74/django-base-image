# Base image to create venv and install requirements
FROM ubuntu:24.04
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  build-essential gcc \
  default-libmysqlclient-dev python3-dev pkg-config \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Create a virtual environment and set it as the default Python environment
RUN uv venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
ENV VIRTUAL_ENV=/opt/venv
