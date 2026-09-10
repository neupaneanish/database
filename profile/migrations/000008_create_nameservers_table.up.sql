create table if not exists nameservers
(
    id         uuid primary key not null default uuidv7(),

    ip_type    citext           not null,
    ip         citext           not null,

    created_at timestamptz      not null default now(),
    created_by uuid             not null,

    updated_at timestamptz      not null default now(),
    updated_by uuid             not null,

    constraint check_created_updated_at
        check ( updated_at >= created_at ),

    constraint unique_name_server
        unique (ip_type, ip)
);

create index if not exists idx_nameservers_created_by
    on nameservers (created_by);

create index if not exists idx_nameservers_updated_by
    on nameservers (updated_by);