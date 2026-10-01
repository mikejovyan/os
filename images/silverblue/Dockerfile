FROM scratch AS ctx
COPY build.sh /build.sh
COPY system_files /system_files
COPY cosign.pub /cosign.pub

FROM quay.io/fedora-ostree-desktops/silverblue:44.20261001.0@sha256:699ab736b43bdd34adb302b5274d00987802df6bd99bf53ec40c44effbe34363

# Avoid committing registry
ARG IMAGE_REF

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    --mount=type=tmpfs,dst=/run/dnf \
    /ctx/build.sh

RUN --mount=type=tmpfs,dst=/run \
    --network=none \
    bootc container lint
