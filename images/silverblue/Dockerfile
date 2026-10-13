FROM scratch AS ctx
COPY build.sh /build.sh
COPY system_files /system_files
COPY cosign.pub /cosign.pub

FROM quay.io/fedora-ostree-desktops/silverblue:44.20261013.0@sha256:d13c3b8b7a3dda9339fc51f4c633fa362100a94b75f0104b60ed441ec98ea0c1

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
