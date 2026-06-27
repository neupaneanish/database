-- name: CreateEducation :one
insert into educations (user_id,
                        school,
                        degree,
                        affiliation,
                        field_of_study,
                        concentration,
                        start_date,
                        end_date,
                        address,
                        description,
                        created_by,
                        updated_by)
values (@user_id,
        @school,
        @degree,
        @affiliation,
        @field_of_study,
        @concentration,
        @start_date,
        @end_date,
        @address,
        @description,
        @created_by,
        @updated_by)
returning *;

-- name: UpdateEducation :one
update educations
set school         = @school,
    degree         = @degree,
    affiliation    = @affiliation,
    field_of_study = @field_of_study,
    concentration  = @concentration,
    start_date     = @start_date,
    end_date       = @end_date,
    address        = @address,
    description    = @description,
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
       address,
       description) is distinct from (@school,
                                      @degree,
                                      @affiliation,
                                      @field_of_study,
                                      @concentration,
                                      @start_date,
                                      @end_date,
                                      @address,
                                      @description)
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