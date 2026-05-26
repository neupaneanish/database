create table if not exists users
(
    id                uuid primary key not null default uuidv7(),

    email             citext unique    not null,
    username          citext unique    not null,

    role              text             not null,
    status            text             not null,

    search            tsvector generated always as (
        to_tsvector('simple', email || ' ' || username)
        ) stored,

    email_verified_at timestamptz,

    created_at        timestamptz      not null default clock_timestamp(),
    created_by        uuid             not null,
    updated_at        timestamptz      not null default clock_timestamp(),
    updated_by        uuid             not null,

    constraint check_created_updated_at
        check ( updated_at >= created_at ),
    constraint check_email_verified
        check ( email_verified_at is null or email_verified_at >= created_at )
);

create index if not exists idx_user_created_by
    on users (created_by);

create index if not exists idx_user_updated_by
    on users (updated_by);

create index if not exists idx_users_search
    on users using gin (search);

create index if not exists idx_users_status
    on users (status);

create index if not exists idx_users_role
    on users (role);

create index if not exists idx_users_username_trgm
    on users using gin (username gin_trgm_ops);

create index if not exists idx_users_email_trgm
    on users using gin (email gin_trgm_ops);