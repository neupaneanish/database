create table if not exists credentials
(
    id         uuid primary key not null default uuidv7(),

    user_id    uuid             not null references users (id) on delete cascade,

    password   bytea            not null,

    created_at timestamptz      not null default now(),
    created_by uuid             not null
);


create index if not exists idx_credentials_user_id
    on credentials (user_id, id desc);

create index if not exists idx_credentials_created_by
    on credentials (created_by);