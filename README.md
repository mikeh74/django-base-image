# Django Base Image

A general purpose base image for Django projects. This image is based on the
official Ubuntu 24.04 image and includes common dependencies for a Django
applications that use MySQL as the database backend.

This is intended to be used as a generic base image for Django applications,
and is not intended to be used as a standalone image.

It does not include any application code or python packages these should be
added in a separate image that extends this base image.

This image contains a lot of additional dependencies that are needed for the
build phase but are not needed at runtime. The runtime image should use a
multi-stage build to copy only the necessary files from this image to the
final image.

An example Dockerfile using this as a base might look like this:

```
FROM ghcr.io/lte-packages/django-base-image:latest as compile-image

RUN --mount=type=cache,target=/root/.cache/uv \
    UV_COMPILE_BYTECODE=1 \
    uv pip install -r requirements.txt

FROM ubuntu:24.04

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install additional runtime dependencies required by dev and production environments
RUN apt-get update \
    && apt-get install -y --no-install-recommends default-mysql-client \
    libcairo2-dev libjpeg-dev libgif-dev curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy the virtual environment from the compile image and add it to the PATH
COPY --from=compile-image /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

```

This is a simplified example.

## Runtime dependencies

A Django CMS application using MySQL, Redis, Solr and LDAP authentication needs
the following shared libraries at runtime. These are the packages to install
in the final (runtime) image; the `-dev` headers and compilers in this image
are only needed to build Python packages.

| Service / feature | Apt package (Ubuntu 24.04) | Used by |
|---|---|---|
| MySQL client | `libmysqlclient21` | `mysqlclient` |
| LDAP | `libldap2` | `python-ldap`, `django-auth-ldap` |
| SASL (LDAP auth) | `libsasl2-2` | `python-ldap` |
| TLS / crypto | `libssl3t64`, `libffi8`, `ca-certificates` | `cryptography`, `cffi`, HTTPS / LDAPS |
| Images | `libjpeg-turbo8`, `zlib1g`, `libfreetype6` | `Pillow` |
| XML | `libxml2`, `libxslt1.1` | `lxml` |

Redis (`redis-py`) and Solr (`pysolr`) are pure Python and need no runtime
system packages. Connecting to them only requires network access to the
servers.

Example runtime install:

```dockerfile
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  libmysqlclient21 \
  libldap2 \
  libsasl2-2 \
  libssl3t64 \
  libffi8 \
  ca-certificates \
  libjpeg-turbo8 \
  zlib1g \
  libfreetype6 \
  libxml2 \
  libxslt1.1 \
  && rm -rf /var/lib/apt/lists/*
```
