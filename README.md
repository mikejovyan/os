# os

Bootable container images.

## Images

| Image | Description |
|---|---|
| [silverblue](images/silverblue/) | Custom Fedora Silverblue image |

## silverblue

Custom [Fedora Silverblue](https://fedoraproject.org/atomic-desktops/silverblue/) image.

### Features

- Fedora Silverblue 44 as the base, bumped daily
- Signed with cosign; the system policy only accepts this image
- OS updates stage automatically; GNOME Software's update handling is off
- Firefox RPM removed, apps come from Flathub
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

### Package management

- **OS updates:** GNOME Software's update handling is disabled. `rpm-ostreed-automatic` stages daily updates, which are applied on the next reboot. Undo an update with `rpm-ostree rollback`, or rebase to Fedora Silverblue with `sudo rpm-ostree rebase fedora:fedora/44/x86_64/silverblue`.

- **GUI apps:** intended to be run as Flathub Flatpaks installed with `flatpak install ...`. To switch from Fedora's Flatpaks to Flathub, run these once:

1. Add the Flathub remote

```shell
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

2. Enable the Flathub remote

```shell
flatpak remote-modify --enable flathub
```

3. Replace the Fedora Flatpaks with Flathub

```shell
flatpak install --reinstall flathub $(flatpak list --app-runtime=org.fedoraproject.Platform --columns=application)
```

4. Remove unused runtimes

```shell
flatpak uninstall --unused
```

5. Disable the Fedora remote

```shell
flatpak remote-modify --disable fedora
```

### Verification

These images are signed with sigstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by running the following command:

```shell
IMAGE=<registry>/mikejovyan/silverblue
cosign verify --key images/silverblue/cosign.pub $IMAGE:latest
```

### References

- [https://github.com/ublue-os/image-template](https://github.com/ublue-os/image-template)
- [https://github.com/astrovm/amyos](https://github.com/astrovm/amyos)
- [https://github.com/bsherman/bos](https://github.com/bsherman/bos)
- [https://github.com/bketelsen/homer](https://github.com/bketelsen/homer)
- [https://github.com/m2Giles/m2os](https://github.com/m2Giles/m2os)
- [https://github.com/Venefilyn/veneos](https://github.com/Venefilyn/veneos)
