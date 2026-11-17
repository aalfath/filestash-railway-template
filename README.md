# Filestash on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/filestash-2?utm_medium=integration&utm_source=button&utm_campaign=filestash)

A Railway template for [Filestash](https://github.com/mickael-kerjean/filestash), an open-source web file manager that puts one browser UI in front of S3, SFTP, FTP, WebDAV, SMB, Git, Backblaze B2, Azure Blob, Google Drive, Dropbox and more, with previews, sharing links and an admin console.

## What it deploys

One service built from this repo, with a Railway volume at `/app/data/state`. The `Dockerfile` pins the official image `machines/filestash` by digest and adds a small start script (`docker-entrypoint.sh`) that:

- listens on Railway's `PORT` (8334);
- keeps all state on the volume: `config.json`, the SQLite databases (shares, tags), the search index, plugins and logs, plus a `files` folder for the built-in Local storage;
- hashes the generated `FILESTASH_ADMIN_PASSWORD` with bcrypt and hands it to Filestash, so the admin console is never left open for whoever finds the URL first;
- on the first boot only, enables one "Local" storage connection limited to `/app/data/state/files`, so you can log in and upload straight away;
- gives a fresh volume to the image's unprivileged `filestash` user (UID 1000) and runs the app as that user.

Health check: `/healthz` (Filestash's own check of its config and HTTP server).

**Version.** Upstream publishes only a rolling `latest` tag, no version tags. This repo pins the `latest` image of 2026-11-16 (Filestash v0.6, upstream commit of 2026-11-16) by its digest, so a redeploy never changes the app under you. New upstream builds reach you through this repo (see Updates).

## Variables

| Variable | Default | What it does |
|---|---|---|
| `PORT` | `8334` | Port Filestash listens on; Railway routes the public domain to it |
| `FILESTASH_ADMIN_PASSWORD` | generated | Password for the admin console at `/admin` and for the Local storage login. Applied on every start, so change it here, not in the console |

## After deploy

1. Open the public URL. Log in to **Local** with the `FILESTASH_ADMIN_PASSWORD` value from the service's Variables tab. Files you upload are stored on the volume.
2. Open `/admin` with the same password to add storage (S3, SFTP, WebDAV, ...), an identity provider (LDAP, SAML, OIDC, htpasswd) or to remove the Local connection.
3. Optional: set **Settings > General > host** to your domain once it is final. Filestash then refuses API calls that come through any other host name.

## Updates

New Filestash builds land here as a change to the pinned digest in the `Dockerfile`, with an entry in [`CHANGELOG.md`](CHANGELOG.md). When it's merged to `main`, Railway shows everyone who deployed the template an "update available" notice, and you choose when to apply it. Your configuration and files stay on the volume.

## Run it locally

```sh
docker build -t filestash-railway .
docker run -p 8334:8334 -e PORT=8334 -e FILESTASH_ADMIN_PASSWORD=change-me -v filestash-state:/app/data/state filestash-railway
```
