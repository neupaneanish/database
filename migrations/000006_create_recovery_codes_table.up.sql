create table if not exists recovery_codes
(
    id         uuid primary key not null default uuidv7(),
    user_id    uuid             not null references users (id) on delete cascade,

    code       bytea            not null,
    used_at    timestamptz,

    created_at timestamptz      not null default now(),
    created_by uuid             not null,

    updated_at timestamptz      not null default now(),
    updated_by uuid             not null,

    constraint check_created_updated_at
        check ( updated_at >= created_at )
);

create index if not exists idx_recovery_codes_unused
    on recovery_codes (user_id)
    where used_at is null;

create index if not exists idx_recovery_codes_created_by
    on recovery_codes (created_by);

create index if not exists idx_recovery_codes_updated_by
    on recovery_codes (updated_by);