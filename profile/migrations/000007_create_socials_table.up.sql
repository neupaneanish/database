create table if not exists socials
(
    id         uuid primary key not null default uuidv7(),

    user_id    uuid             not null,
    icon_id    uuid             not null references icons (id) on delete cascade,

    username   varchar(30)      not null,

    created_at timestamptz      not null default now(),
    created_by uuid             not null,

    updated_at timestamptz      not null default now(),
    updated_by uuid             not null,

    constraint check_created_updated_at
        check ( updated_at >= created_at )
);

create unique index if not exists unique_socials_user_id_icon_id
    on socials (user_id, icon_id);

create index if not exists idx_socials_created_by
    on socials (created_by);

create index if not exists idx_socials_updated_by
    on socials (updated_by);
