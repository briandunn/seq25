create table if not exists songs (
  id serial primary key not null,
  data json not null,
  parent_id integer references songs(id),
  created_at timestamptz not null default now()
);
