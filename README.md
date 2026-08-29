# Django Base Image

A general purpose base image for Django projects. This image is based on the
official Ubuntu 24.04 image and includes common dependencies for a Django
applications that use MySQL as the database backend.

This is intended to be used as a generic base image for Django applications,
and is not intended to be used as a standalone image.

It does not include any application code or python packages these should be
added in a separate image that extends this base image.

This image contains a lot of additional dependencies that are needed for the
buil phase but are not needed at runtime. The runtime image should use a
multi-stage build to copy only the necessary files from this image to the
final image.
