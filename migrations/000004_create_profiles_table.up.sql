create table if not exists profiles
(
    id         uuid primary key   not null default uuidv7(),
    user_id    uuid unique        not null references users (id) on delete cascade,

    name       varchar(64)        not null,
    avatar     text,
    about      text,
    dob        date               not null,
    phone      varchar(15) unique not null,

    created_at timestamptz        not null default now(),
    created_by uuid               not null,

    updated_at timestamptz        not null default now(),
    updated_by uuid               not null,

    constraint check_created_updated_at
        check ( updated_at >= created_at )
);

create index if not exists idx_profile_created_by
    on profiles (created_by, created_at desc);

create index if not exists idx_profile_updated_by
    on profiles (updated_by, updated_at desc);