#!/bin/bash

set -ouex pipefail

# Avoid committing the registry by taking it as a build-arg
: "${IMAGE_REF:?IMAGE_REF build-arg is required, e.g. --build-arg IMAGE_REF=host/owner/image}"

cp -avf "/ctx/system_files"/. /

systemctl enable rpm-ostreed-automatic.timer

glib-compile-schemas /usr/share/glib-2.0/schemas

# The default must be reject: ostree-image-signed refuses insecureAcceptAnything
cat >/etc/containers/policy.json <<EOF
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

cat >/etc/containers/registries.d/silverblue.yaml <<EOF
docker:
  "${IMAGE_REF}":
    use-sigstore-attachments: true
EOF

install -Dm0644 /ctx/cosign.pub /etc/pki/containers/silverblue.pub

dnf5 install -y fedora-repos-ostree

dnf5 remove -y firefox

fedora_version=$(rpm -E %fedora)
dnf5 install -y \
    "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${fedora_version}.noarch.rpm" \
    "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${fedora_version}.noarch.rpm"

dnf5 install -y --allowerasing ffmpegthumbnailer libheif-freeworld libheif-tools
