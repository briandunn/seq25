# SEQ25

A sequencer inspired by [SEQ24][s].

[s]: http://www.filter24.org/seq24/

- `frontend/`: the Ember app (Ember 7, TypeScript, Vite). Songs live in
  the browser's localStorage. See [frontend/README.md](frontend/README.md).
- `backend/`: a small Rack API (Ruby 4, Postgres) for sharing songs: `POST
  /songs`, `GET /songs`, `GET /songs/:id`.

## Development

Everything runs in Docker:

```sh
docker compose up
```

- <http://localhost:4200>: the app, hot-reloading from `./frontend`, with
  `/songs` proxied to the backend.
- `docker compose exec frontend aube test` runs the frontend tests.
- `docker compose exec frontend aube run lint` runs the linters.

To run the backend spec:

```sh
docker compose exec -T postgres createdb -U seq25 seq25test   # once
docker compose run --rm -T \
  -e PGHOST=postgres -e PGUSER=seq25 -e PGPASSWORD=seq25 \
  backend bundle exec ruby specs/server_spec.rb
```

To work on the frontend outside Docker, `mise install` gets the pinned node and
aube (see `mise.toml`).

## Deploying

Production runs on a single Docker host:

- The backend runs as the `seq25-prod` compose stack (`compose.prod.yaml`),
  listening only on `127.0.0.1:3025`.
- The host's nginx serves the built frontend from `/var/www/seq25` and
  proxies `/songs` to the backend (`deploy/nginx/seq25.conf`).

```sh
./deploy.sh
```

This builds and starts the backend, builds the frontend, and publishes it. It
deploys only committed code, unless you set `ALLOW_DIRTY=1`.

One-time setup, as root. First set `server_name` in
`deploy/nginx/seq25.conf` to your domain:

```sh
install -d -o "$SUDO_USER" /var/www/seq25
cp deploy/nginx/seq25.conf /etc/nginx/sites-available/seq25.conf
ln -s ../sites-available/seq25.conf /etc/nginx/sites-enabled/
nginx -t && systemctl reload nginx
certbot --nginx -d seq25.example.com
```

## Keyboard

Press `?` in the app for the full list.

Most commands take a count typed first (`2 0 b` sets 20 beats). Part commands
take a part letter first (`q w e r a s d f`) and otherwise apply to the part
you're editing.

### Anywhere in a song

| Key | Action |
|---|---|
| space | play / stop |
| `t` | go to the song's parts |
| `g` | go to a part (creating it if needed) |
| `b` | set beats for a part (bare `b` adds one) |
| `x` | set quant (bare `x` adds one) |
| `n` / shift+`n` | raise / lower a part's volume |
| `m` | toggle mute for a part |
| `o` | solo a part |
| shift+`m` / shift+`o` | mute / unmute all |

### Editing a part

| Key | Action |
|---|---|
| `c` | create a note |
| click / shift+click / drag | select notes / add to the selection / box-select |
| left, right | move selected notes |
| up, down | change their pitch |
| shift+left, shift+right | shorten / extend them |
| ctrl+shift+arrows | copy them in that direction |
| `v` | set velocity (`1 0 v` is full) |
| backspace | delete them |
