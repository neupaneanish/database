-- name: CreateEducation :one
insert into educations(user_id,
                       school,
                       degree,
                       affiliation,
                       field_of_study,
                       concentration,
                       start_date,
                       end_date,
                       grade,
                       grade_type,
                       address,
                       description,
                       created_by,
                       updated_by)
values (@user_id,
        @school,
        @degree,
        sqlc.narg('affiliation'),
        sqlc.narg('field_of_study'),
        sqlc.narg('concentration'),
        @start_date,
        sqlc.narg('end_date'),
        sqlc.narg('grade'),
        sqlc.narg('grade_type'),
        @address,
        sqlc.narg('description'),
        @created_by,
        @updated_by)
returning *;

-- name: UpdateEducation :one
update educations
set school         = coalesce(sqlc.narg('school'), school),
    degree         = coalesce(sqlc.narg('degree'), degree),
    affiliation    = coalesce(sqlc.narg('affiliation'), affiliation),
    field_of_study = coalesce(sqlc.narg('field_of_study'), field_of_study),
    concentration  = coalesce(sqlc.narg('concentration'), concentration),
    start_date     = coalesce(sqlc.narg('start_date'), start_date),
    end_date       = coalesce(sqlc.narg('end_date'), end_date),
    grade          = coalesce(sqlc.narg('grade'), grade),
    grade_type     = coalesce(sqlc.narg('grade_type'), grade_type),
    address        = coalesce(sqlc.narg('address'), address),
    description    = coalesce(sqlc.narg('description'), description),
    updated_at     = now(),
    updated_by     = @updated_by
where id = @id
  and user_id = @user_id
  and updated_at = @updated_at::timestamptz
  and (school,
       degree,
       affiliation,
       field_of_study,
       concentration,
       start_date,
       end_date,
       grade,
       grade_type,
       address,
       description) is distinct from (
                                      coalesce(sqlc.narg('school'), school),
                                      coalesce(sqlc.narg('degree'), degree),
                                      coalesce(sqlc.narg('affiliation'), affiliation),
                                      coalesce(sqlc.narg('field_of_study'), field_of_study),
                                      coalesce(sqlc.narg('concentration'), concentration),
                                      coalesce(sqlc.narg('start_date'), start_date),
                                      coalesce(sqlc.narg('end_date'), end_date),
                                      coalesce(sqlc.narg('grade'), grade),
                                      coalesce(sqlc.narg('grade_type'), grade_type),
                                      coalesce(sqlc.narg('address'), address),
                                      coalesce(sqlc.narg('description'), description)
    )
returning *;

-- name: Education :one
select *
from educations
where id = @id
  and user_id = @user_id;

-- name: Educations :many
select *
from educations
where user_id = @user_id
order by (end_date is null) desc,
         end_date desc nulls last,
         start_date desc;

-- name: DeleteEducation :execresult
delete
from educations
where id = @id
  and user_id = @user_id
  and updated_at = @updated_at::timestamptz;