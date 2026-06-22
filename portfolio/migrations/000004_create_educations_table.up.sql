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

    grade          numeric(5, 2),
    grade_type     varchar(64),

    address        varchar(256)     not null,
    description    text,

    created_at     timestamptz      not null default now(),
    created_by     uuid             not null,

    updated_at     timestamptz      not null default now(),
    updated_by     uuid             not null,

    constraint check_created_updated_at
        check ( updated_at >= created_at ),

    constraint check_dates
        check ( end_date is null or end_date > start_date ),

    constraint check_grade_range
        check ( grade between 0.00 and 100.00 ),

    constraint check_grade_and_type_coexistence
        check ( (grade is null and grade_type is null) or
                (grade is not null and grade_type is not null) )
);

create index if not exists idx_educations_user_id
    on educations (user_id, (end_date is null) desc, end_date desc nulls last, start_date desc);

create index if not exists idx_educations_created_by
    on educations (created_by);

create index if not exists idx_educations_updated_by
    on educations (updated_by);