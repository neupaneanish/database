create table abouts
(
    id         uuid primary key not null default uuidv7(),
    user_id    uuid unique      not null,
    about      text             not null,
    created_at timestamptz      not null default now(),
    created_by uuid             not null,
    updated_at timestamptz      not null default now(),
    updated_by uuid             not null,
    constraint check_created_updated_at
        check ( updated_at >= created_at )
);

create index if not exists idx_abouts_created_by
    on abouts (created_by);

create index if not exists idx_abouts_updated_by
    on abouts (updated_by);