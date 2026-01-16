# 04. Docker on OMV/Debian

Install Docker Engine + Compose plugin using the official Docker apt repository method.

After install, validate:

```bash
docker version
docker compose version
docker run --rm hello-world
```

Optional (quality of life):

```bash
usermod -aG docker media
```

Log out/in for group membership to apply.
