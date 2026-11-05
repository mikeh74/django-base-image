# Base image to create venv and install requirements
FROM ubuntu:24.04
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# Build headers for compiling Python packages:
#   mysqlclient (MySQL), python-ldap/django-auth-ldap (LDAP),
#   cryptography/cffi (SSL, libffi), Pillow (JPEG/zlib/freetype),
#   lxml (libxml2/libxslt). redis-py and pysolr are pure Python.
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  build-essential gcc \
  pkg-config \
  default-libmysqlclient-dev \
  libldap2-dev \
  libsasl2-dev \
  libssl-dev \
  libffi-dev \
  libjpeg-dev \
  zlib1g-dev \
  libfreetype6-dev \
  libxml2-dev \
  libxslt1-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Create a virtual environment and set it as the default Python environment
RUN uv venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
ENV VIRTUAL_ENV=/opt/venv
