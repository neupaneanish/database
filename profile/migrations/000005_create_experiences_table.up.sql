create table if not exists experiences
(
    id            uuid primary key not null default uuidv7(),
    user_id       uuid             not null,

    title         varchar(64)      not null,
    company_name  varchar(256)     not null,

    location      varchar(128)     not null,
    location_type varchar(64)      not null,

    start_date    date             not null,
    end_date      date,

    description   text,

    search         tsvector generated always as (to_tsvector('simple', title || ' ' || company_name)) stored,

    created_at    timestamptz      not null default now(),
    created_by    uuid             not null,

    updated_at    timestamptz      not null default now(),
    updated_by    uuid             not null,

    constraint check_created_updated_at
        check ( updated_at >= created_at ),

    constraint check_dates
        check ( end_date is null or end_date > start_date )
);

create index if not exists idx_experiences_search
    on experiences using gin (search);

create index if not exists idx_experiences_title_trgm
    on experiences using gin (title gin_trgm_ops);

create index if not exists idx_experiences_company_name_trgm
    on experiences using gin (company_name gin_trgm_ops);

create index if not exists idx_experiences_user_id
    on experiences (user_id, (end_date is null) desc, end_date desc nulls last, start_date desc);

create index if not exists idx_experiences_created_by
    on experiences (created_by);

create index if not exists idx_experiences_updated_by
    on experiences (updated_by);