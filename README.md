# silverblue

Custom [Fedora Silverblue](https://fedoraproject.org/atomic-desktops/silverblue/) bootc image, built with [BlueBuild](https://blue-build.org/).

### Features

- Fedora Silverblue 44 as the base, bumped daily
- Signed with cosign; the system policy only accepts this image
- Firefox RPM removed; GNOME apps and Firefox come from Flathub automatically on first boot
- RPM Fusion repos enabled, with HEIC and video thumbnails
- Fedora's ostree remote added, so you can rebase back to stock Fedora

### Install

From an existing [Fedora Silverblue](https://fedoraproject.org/atomic-desktops/silverblue/) installation, switch to this image:

1. Give the host a pull credential. The registry requires sign-in. Create a token with `read:package`, then:

```shell
REGISTRY=<registry>
sudo podman login --authfile /etc/ostree/auth.json --username mikejovyan $REGISTRY
```

2. Rebase without verification. The host only gets the signature policy after it has booted the image.

```shell
IMAGE=<registry>/mikejovyan/silverblue
sudo rpm-ostree rebase ostree-unverified-registry:$IMAGE:latest
systemctl reboot
```

3. Switch to verified updates.

```shell
IMAGE=<registry>/mikejovyan/silverblue
sudo rpm-ostree rebase ostree-image-signed:docker://$IMAGE:latest
systemctl reboot
```

### Verification

These images are signed with sigstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by running the following command:

```shell
IMAGE=<registry>/mikejovyan/silverblue
cosign verify --key cosign.pub $IMAGE:latest
```

### References

- [https://github.com/blue-build/template](https://github.com/blue-build/template)
- [https://github.com/ublue-os/image-template](https://github.com/ublue-os/image-template)
