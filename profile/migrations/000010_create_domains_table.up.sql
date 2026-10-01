create table if not exists domains
(
    id            uuid primary key not null default uuidv7(),

    user_id       uuid             not null,
    nameserver_id uuid             not null references nameservers (id) on delete restrict,
    template_id   uuid             not null references templates (id) on delete restrict,

    hostname      citext unique    not null,
    txt           citext unique    not null,
    verified_at   timestamptz,

    search        tsvector generated always as (to_tsvector('simple', hostname)) stored,

    created_at    timestamptz      not null default now(),
    created_by    uuid             not null,

    updated_at    timestamptz      not null default now(),
    updated_by    uuid             not null,

    constraint check_created_updated_at
        check ( updated_at >= created_at ),

    constraint check_verified_at
        check ( verified_at is null or verified_at > created_at )
);

create index if not exists idx_domains_search
    on domains using gin (search);

create index if not exists idx_experiences_hostname_trgm
    on domains using gin (hostname gin_trgm_ops);

create index if not exists idx_domains_user_id
    on domains (user_id);

create index if not exists idx_domains_template_id
    on domains (template_id);

create index if not exists idx_domains_nameserver_id
    on domains (nameserver_id);

create index if not exists idx_domains_created_by
    on domains (created_by);

create index if not exists idx_domains_updated_by
    on domains (updated_by);