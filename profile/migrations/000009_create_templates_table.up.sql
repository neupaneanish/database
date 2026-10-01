create table if not exists templates
(
    id          uuid primary key not null default uuidv7(),
    icon_id     uuid             not null references icons (id) on delete restrict,

    name        citext unique    not null,
    description text             not null,

    created_at  timestamptz      not null default now(),
    created_by  uuid             not null,

    updated_at  timestamptz      not null default now(),
    updated_by  uuid             not null,

    constraint check_created_updated_at
        check ( updated_at >= created_at )
);

create index if not exists idx_templates_created_by
    on templates (created_by);

create index if not exists idx_templates_updated_by
    on templates (updated_by);
