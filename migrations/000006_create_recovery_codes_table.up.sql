create table if not exists recovery_codes
(
    id         uuid primary key not null default uuidv7(),
    user_id    uuid             not null references users (id) on delete cascade,

    code       bytea            not null,
    used_at    timestamptz,

    created_at timestamptz      not null default clock_timestamp(),
    created_by uuid             not null
);

create index if not exists idx_recovery_codes_unused
    on recovery_codes (user_id)
    where used_at is null;

create index if not exists idx_recovery_codes_created_by
    on recovery_codes (created_by);
