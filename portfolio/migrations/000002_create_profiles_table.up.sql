create table profiles
(
    user_id    uuid primary key not null,

    name       varchar(64)      not null,
    headline   varchar(64),
    dob        date             not null,

    created_at timestamptz      not null default now(),
    created_by uuid             not null,

    updated_at timestamptz      not null default now(),
    updated_by uuid             not null,

    constraint check_created_updated_at
        check ( updated_at >= created_at )
);

create index if not exists idx_profiles_created_by
    on profiles (created_by);

create index if not exists idx_profiles_updated_by
    on profiles (updated_by);