create table if not exists icons
(
    id            uuid primary key not null default uuidv7(),

    name          citext unique    not null,

    site_hostname citext           not null,
    site_suffix   citext,

    hostname      citext           not null,
    suffix        citext           not null,

    color         char(7)          not null,

    search        tsvector generated always as (to_tsvector('simple', name)) stored,

    created_at    timestamptz      not null default now(),
    created_by    uuid             not null,

    updated_at    timestamptz      not null default now(),
    updated_by    uuid             not null,

    constraint check_created_updated_at
        check ( updated_at >= created_at )
);

create index if not exists idx_icons_search
    on icons using gin (search);

create index if not exists idx_icons_name_trgm
    on icons using gin (name gin_trgm_ops);

create unique index unique_icons_site_hostname_with_suffix
    on icons (site_hostname, site_suffix)
    where site_suffix is not null;

create unique index unique_icons_site_hostname_no_suffix
    on icons (site_hostname)
    where site_suffix is null;

create unique index unique_hostname_suffix
    on icons (hostname, suffix);

create index if not exists idx_icons_created_by
    on icons (created_by);

create index if not exists idx_icons_updated_by
    on icons (updated_by);