#!/bin/bash

set -ouex pipefail

# Avoid committing the registry by taking it as a build-arg
: "${IMAGE_REF:?IMAGE_REF build-arg is required, e.g. --build-arg IMAGE_REF=host/owner/image}"

# system_files/ mirrors the image's filesystem
cp -avf "/ctx/system_files"/. /

systemctl enable rpm-ostreed-automatic.timer

# The overrides only take effect once the schemas are compiled
glib-compile-schemas /usr/share/glib-2.0/schemas

# The default must be reject: ostree-image-signed refuses insecureAcceptAnything
cat > /etc/containers/policy.json <<EOF
{
    "default": [
        {
            "type": "reject"
        }
    ],
    "transports": {
        "docker": {
            "${IMAGE_REF}": [
                {
                    "type": "sigstoreSigned",
                    "keyPath": "/etc/pki/containers/silverblue.pub",
                    "signedIdentity": {
                        "type": "matchRepository"
                    }
                }
            ]
        }
    }
}
EOF

# Look for cosign signatures attached to the image in the registry
cat > /etc/containers/registries.d/silverblue.yaml <<EOF
docker:
  "${IMAGE_REF}":
    use-sigstore-attachments: true
EOF

install -Dm0644 /ctx/cosign.pub /etc/pki/containers/silverblue.pub

# The base has no fedora ostree remote, which is needed to rebase back to Fedora
dnf5 install -y fedora-repos-ostree

# Firefox comes from Flathub instead
dnf5 remove -y firefox

# RPM Fusion, for libheif-freeworld
fedora_version=$(rpm -E %fedora)
dnf5 install -y \
    "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${fedora_version}.noarch.rpm" \
    "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${fedora_version}.noarch.rpm"

# Thumbnails; --allowerasing because RPM Fusion's libheif lags the base's
dnf5 install -y --allowerasing ffmpegthumbnailer libheif-freeworld libheif-tools
