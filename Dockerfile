# Filestash, pinned by digest. Upstream publishes only a rolling `latest` tag
# (no version tags), so the digest is the pin: machines/filestash `latest` as of
# 2026-11-16 (APP_VERSION v0.6, multi-arch index digest).
FROM machines/filestash@sha256:89e70f0fccc4dcce3f47e5d490ee961f912a5ffd4e30b98216e3e37e469035e2

# Start as root only to fix the ownership of the Railway volume, then drop to the
# image's own `filestash` user (uid 1000) in the entrypoint.
USER root
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod 0755 /usr/local/bin/docker-entrypoint.sh

WORKDIR /app/
EXPOSE 8334
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
