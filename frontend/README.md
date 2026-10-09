# seq25 frontend

The Ember app (Ember 7.3, Vite/Embroider, TypeScript). The backend it talks to
is in `../backend`.

## In Docker (the usual way)

From the repo root:

- `docker compose up` starts Postgres, the backend and this app's Vite dev
  server at <http://localhost:4200>, with `/songs` proxied to the backend.
  `./frontend` is mounted, so edits hot-reload.
- `docker compose exec frontend aube test` runs the tests in the container's
  Chromium.
- `docker compose exec frontend aube run lint` runs the linters.

## On the host

Node and aube versions are pinned in the repo's `mise.toml`, so run
`mise install` first.

- `aube install`
- `aube start` (dev server; expects the backend on `localhost:3001`, or set
  `BACKEND_URL`)
- `aube test` (needs Chrome. Set `CHROME_BIN` to use a Chromium somewhere else
  on disk.)
- `aube run lint` / `aube run lint:fix`
- `aube run build` (production build into `dist/`)
- `aube exec ember help generate` (code generators)

## Dependency notes

- `ember-modifier` is pinned to 4.2.1. aube's trust policy rejects 4.3.0,
  which dropped the provenance attestation that 4.2.1 has. The runtime code in
  the two is identical.
- `tmp` is overridden to `^0.2.7` (via `pnpm.overrides`, which aube reads) to
  fix GHSA-ph9p-34f9-6g65 and GHSA-52f5-9888-hmc6, which come in through
  `external-editor`.
- `aube audit` still reports braces 3.0.3 (GHSA-vfj7-8cjw-p6xm). There is no
  fixed release, and it's only reachable through build-time globbing of our
  own patterns.
- Held back by upstream as of 2026-10-05:
  - ESLint 10 needs `@babel/eslint-parser` 8, which needs Babel 8.
  - Babel 8 is blocked because the Ember build chain (ember-cli-babel,
    embroider, ember-source) is on Babel 7.
  - TypeScript 7 is blocked because typescript-eslint supports `<6.1`.
  - QUnit 3 is blocked because ember-qunit 9 requires `^2.13`.
