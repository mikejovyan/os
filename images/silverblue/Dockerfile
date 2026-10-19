FROM scratch AS ctx
COPY build.sh /build.sh
COPY system_files /system_files
COPY cosign.pub /cosign.pub

FROM quay.io/fedora-ostree-desktops/silverblue:44.20261019.0@sha256:310c9a001a16a948b16e9dba3937973775af8e2034dd8685b4050bbc6918c961

# Avoid committing registry
ARG IMAGE_REF

# renovate: datasource=github-releases depName=FrameworkComputer/framework-system
ARG FRAMEWORK_TOOL_VERSION=0.6.6

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    --mount=type=tmpfs,dst=/run/dnf \
    /ctx/build.sh

RUN --mount=type=tmpfs,dst=/run \
    --network=none \
    bootc container lint
