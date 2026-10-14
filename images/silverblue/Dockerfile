FROM scratch AS ctx
COPY build.sh /build.sh
COPY system_files /system_files
COPY cosign.pub /cosign.pub

FROM quay.io/fedora-ostree-desktops/silverblue:44.20261014.0@sha256:d79a25753b986c40b97c110d26ce138f420e16b3d85243f64086381f6455d90c

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
