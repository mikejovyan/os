FROM scratch AS ctx
COPY build.sh /build.sh
COPY system_files /system_files
COPY cosign.pub /cosign.pub

FROM quay.io/fedora-ostree-desktops/silverblue:44.20260929.0@sha256:0c39b76584df38556808717520519e6c237270e983aaf6af7238a4f79d34f44f

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
