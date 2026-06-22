create table if not exists platforms
(
    id         uuid primary key not null default uuidv7(),

    name       citext unique    not null,
    url        citext unique    not null,
    logo_url   text             not null,
    color      char(7)          not null,

    created_at timestamptz      not null default now(),
    created_by uuid             not null,

    updated_at timestamptz      not null default now(),
    updated_by uuid             not null,

    constraint check_created_updated_at
        check ( updated_at >= created_at )
);

create index if not exists idx_platforms_created_by
    on platforms (created_by);

create index if not exists idx_platforms_updated_by
    on platforms (updated_by);