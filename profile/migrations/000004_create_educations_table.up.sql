create table if not exists educations
(
    id             uuid primary key not null default uuidv7(),
    user_id        uuid             not null,

    school         varchar(256)     not null,
    degree         varchar(64)      not null,

    affiliation    varchar(256),
    field_of_study varchar(256),
    concentration  varchar(256),

    start_date     date             not null,
    end_date       date,

    address        varchar(256)     not null,
    description    text,

    created_at     timestamptz      not null default now(),
    created_by     uuid             not null,

    updated_at     timestamptz      not null default now(),
    updated_by     uuid             not null,

    constraint check_created_updated_at
        check ( updated_at >= created_at ),

    constraint check_dates
        check ( end_date is null or end_date > start_date )
);

create index if not exists idx_educations_user_id
    on educations (user_id, (end_date is null) desc, end_date desc nulls last, start_date desc);

create index if not exists idx_educations_created_by
    on educations (created_by);

create index if not exists idx_educations_updated_by
    on educations (updated_by);