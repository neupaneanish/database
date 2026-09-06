create table if not exists name_servers
(
    id         uuid primary key not null default uuidv7(),

    domain     citext           not null,
    cname      citext           not null,

    active     boolean          not null default true,

    created_at timestamptz      not null default now(),
    created_by uuid             not null,

    updated_at timestamptz      not null default now(),
    updated_by uuid             not null,

    constraint check_created_updated_at
        check ( updated_at >= created_at ),

    constraint unique_name_server
        unique (domain, cname)
);

create index if not exists idx_name_servers_created_by
    on name_servers (created_by);

create index if not exists idx_name_servers_updated_by
    on name_servers (updated_by);