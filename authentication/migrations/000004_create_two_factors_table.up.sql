create table if not exists two_factors
(
    user_id      uuid primary key not null references users (id) on delete cascade,

    secret       bytea            not null,

    enabled_at   timestamptz      not null default now(),
    verified_at  timestamptz      not null default now(),
    last_used_at timestamptz      not null default now(),

    created_at   timestamptz      not null default now(),
    created_by   uuid             not null,

    updated_at   timestamptz      not null default now(),
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