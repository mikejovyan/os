#!/usr/bin/env bash

# Downloads a single release asset from a GitHub repo and installs it as an
# executable. Config:
#   repo: owner/name       -- e.g. FrameworkComputer/framework-system
#   tag: the release tag   -- optional, defaults to "latest"
#   asset: the asset name  -- e.g. framework_tool
#   dest: install path     -- optional, defaults to /usr/bin/<asset>

set -euo pipefail

params="$1"

repo=$(jq -r '.repo' <<< "${params}")
tag=$(jq -r '.tag // "latest"' <<< "${params}")
asset=$(jq -r '.asset' <<< "${params}")
dest=$(jq -r '.dest // ("/usr/bin/" + .asset)' <<< "${params}")

if [ "${tag}" = "latest" ]; then
  url="https://github.com/${repo}/releases/latest/download/${asset}"
else
  url="https://github.com/${repo}/releases/download/${tag}/${asset}"
fi

echo "Installing ${asset} (${repo}@${tag}) to ${dest}"

wget --no-hsts --quiet -O- "${url}" |
  install -Dm0755 /dev/stdin "${dest}"
