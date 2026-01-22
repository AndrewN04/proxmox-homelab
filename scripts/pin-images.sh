#!/usr/bin/env bash
set -euo pipefail

# After first successful deployment, pin images to digests:
# Example:
#   docker pull lscr.io/linuxserver/sonarr:latest
#   docker inspect --format='{{index .RepoDigests 0}}' lscr.io/linuxserver/sonarr:latest
# Then replace the image reference with `image: <name>@sha256:<digest>`.

echo "Pinning is manual by design. Edit stack compose files after collecting digests."
