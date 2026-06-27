create table if not exists socials
(
    id          uuid primary key not null default uuidv7(),
    user_id     uuid             not null,
    platform_id uuid             not null references platforms (id) on delete cascade,

    username    citext           not null,

    created_at  timestamptz      not null default now(),
    created_by  uuid             not null,

    updated_at  timestamptz      not null default now(),
    updated_by  uuid             not null,

    constraint check_created_updated_at
        check ( updated_at >= created_at ),

    constraint unique_user_platform
        unique (user_id, platform_id)
);

create index if not exists idx_socials_created_by
    on socials (created_by);

create index if not exists idx_socials_updated_by
    on socials (updated_by);
