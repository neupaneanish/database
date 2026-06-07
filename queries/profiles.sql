-- name: CreateProfile :one
insert into profiles(user_id, name, avatar, about, dob, phone, created_by, updated_by)
values (@user_id, @name, @avatar, @about, @dob, @phone, @created_by, @updated_by)
returning *;

-- name: UpdateProfile :one
update profiles
set avatar     = coalesce(sqlc.narg('avatar'), avatar),
    about      = coalesce(sqlc.narg('about'), about),
    phone      = coalesce(sqlc.narg('phone'), phone),
    updated_at = now(),
    updated_by = @updated_by
where id = @id
  and user_id = @user_id
  and updated_at = @updated_at::timestamptz
  and (coalesce(sqlc.narg('avatar'), avatar),
       coalesce(sqlc.narg('about'), about),
       coalesce(sqlc.narg('phone'), phone) is distinct from (avatar, about, phone))
returning *;

-- name: Profile :one
select *
from profiles
where user_id = @user_id;