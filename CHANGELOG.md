# Changelog

Each entry lists breaking changes first. Read it before you apply an "update available" notice on Railway.

## 0.6-20261116 (2026-11-17)

- First release of this template: Filestash v0.6, official image `machines/filestash@sha256:89e70f0fccc4dcce3f47e5d490ee961f912a5ffd4e30b98216e3e37e469035e2` (upstream `latest` built 2026-11-16; upstream publishes no version tags).
- Listens on Railway's `PORT` (8334), keeps all state on a volume at `/app/data/state`, runs as the image's `filestash` user (UID 1000).
- Admin password generated at deploy time (`FILESTASH_ADMIN_PASSWORD`), hashed with bcrypt at start.
- First boot enables a "Local" storage connection limited to `/app/data/state/files`.
- Health check at `/healthz`.
