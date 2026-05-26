create table if not exists two_factors
(
    id           uuid primary key not null default uuidv7(),
    user_id      uuid unique      not null references users (id) on delete cascade,

    secret       bytea            not null,

    enabled_at   timestamptz      not null default clock_timestamp(),
    verified_at  timestamptz      not null default clock_timestamp(),
    last_used_at timestamptz      not null default clock_timestamp(),

    created_at   timestamptz      not null default clock_timestamp(),
    created_by   uuid             not null,

    updated_at   timestamptz      not null default clock_timestamp(),
    updated_by   uuid             not null,

    constraint check_created_updated_at
        check ( updated_at >= created_at ),

    constraint check_enabled_created_at
        check (enabled_at >= created_at),

    constraint check_verified_enabled_at
        check ( verified_at >= enabled_at )
);

create index if not exists idx_two_factors_created_by
    on two_factors (created_by);

create index if not exists idx_two_factors_updated_by
    on two_factors (updated_by);