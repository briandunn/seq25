# Dev and test image for the Ember app. Build context is the repo root so the
# shared mise.toml (node + aube versions) is available.
FROM debian:trixie-slim

# Chromium runs the test suite (testem launches it headless).
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates \
      chromium \
      git \
    && rm -rf /var/lib/apt/lists/*

COPY --from=jdxcode/mise:2026.10.2 /usr/local/bin/mise /usr/local/bin/mise
ENV MISE_DATA_DIR=/mise \
    MISE_YES=1 \
    PATH=/mise/shims:$PATH

WORKDIR /app
COPY --chmod=644 mise.toml mise.lock ./
RUN mise trust /app/mise.toml && mise install

# Run as the host user's uid so files written through the dev bind mount
# (tmp/, dist/, caches) stay owned by you rather than root.
ARG UID=1000
RUN useradd --create-home --uid ${UID} dev \
    && mkdir -p /app/frontend && chown dev:dev /app/frontend
USER dev

WORKDIR /app/frontend
COPY --chown=dev:dev frontend/package.json frontend/aube-lock.yaml ./
COPY --chown=dev:dev frontend/.config/aube/config.toml ./.config/aube/config.toml
RUN aube install --frozen-lockfile

COPY --chown=dev:dev frontend/ ./

# testem adds --no-sandbox under CI; Chrome's sandbox can't start inside a
# default Docker container.
ENV CI=true \
    CHROME_BIN=/usr/bin/chromium

EXPOSE 4200

CMD ["aube", "start", "--host", "0.0.0.0", "--port", "4200"]
