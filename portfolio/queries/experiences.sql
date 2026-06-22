-- name: CreateExperience :one
insert into experiences(user_id,
                        title,
                        company_name,
                        location,
                        location_type,
                        start_date,
                        end_date,
                        description,
                        created_by,
                        updated_by)
values (@user_id,
        @title,
        @company_name,
        @location,
        @location_type,
        @start_date,
        sqlc.narg('end_date'),
        sqlc.narg('description'),
        @created_by,
        @updated_by)
returning *;

-- name: UpdateExperience :one
update experiences
set title         = coalesce(sqlc.narg('title'), title),
    company_name  = coalesce(sqlc.narg('company_name'), company_name),
    location      = coalesce(sqlc.narg('location'), location),
    location_type = coalesce(sqlc.narg('location_type'), location_type),
    start_date    = coalesce(sqlc.narg('start_date'), start_date),
    end_date      = coalesce(sqlc.narg('end_date'), end_date),
    description   = coalesce(sqlc.narg('description'), description),
    updated_at    = now(),
    updated_by    = @updated_by
where id = @id
  and user_id = @user_id
  and updated_at = @updated_at::timestamptz
  and (title,
       company_name,
       location,
       location_type,
       start_date,
       end_date,
       description) is distinct from (
                                      coalesce(sqlc.narg('title'), title),
                                      coalesce(sqlc.narg('company_name'), company_name),
                                      coalesce(sqlc.narg('location'), location),
                                      coalesce(sqlc.narg('location_type'), location_type),
                                      coalesce(sqlc.narg('start_date'), start_date),
                                      coalesce(sqlc.narg('end_date'), end_date),
                                      coalesce(sqlc.narg('description'), description)
    )
returning *;

-- name: Experience :one
select *
from experiences
where id = @id
  and user_id = @user_id;

-- name: Experiences :many
select *
from experiences
where user_id = @user_id
order by (end_date is null) desc,
         end_date desc nulls last,
         start_date desc;

-- name: DeleteExperience :execresult
delete
from experiences
where id = @id
  and user_id = @user_id
  and updated_at = @updated_at::timestamptz;