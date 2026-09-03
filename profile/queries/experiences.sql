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
        @end_date,
        @description,
        @created_by,
        @updated_by)
returning id;

-- name: UpdateExperience :one
update experiences
set title         = @title,
    company_name  = @company_name,
    location      = @location,
    location_type = @location_type,
    start_date    = @start_date,
    end_date      = @end_date,
    description   = @description,
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
       description) is distinct from (@title,
                                      @company_name,
                                      @location,
                                      @location_type,
                                      @start_date,
                                      @end_date,
                                      @description)
returning id;

-- name: Experience :one
select id, user_id, title, company_name, start_date, end_date
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