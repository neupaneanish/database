-- name: CreateProfile :execresult
insert into profiles (user_id, name, title, dob, created_by, updated_by)
values (@user_id, @name, @title, @dob, @created_by, @updated_by);

-- name: UpdateProfile :one
update profiles
set name       = @name,
    title      = @title,
    updated_at = now(),
    updated_by = @updated_by
where user_id = @user_id
  and updated_at = @updated_at::timestamptz
  and (name, title) is distinct from (@name, @title)
returning *;

-- name: Profile :one
select *
from profiles
where user_id = @user_id;

-- name: CheckProfile :one
select exists(select 1
              from profiles
              where user_id = @user_id) as profile_exists;