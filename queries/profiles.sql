-- name: CreateProfile :one
insert into profiles(user_id, name, avatar, about, dob, phone, created_by, updated_by)
values (@user_id, @name, @avatar, @about, @dob, @phone, @created_by, @updated_by)
returning *;

-- name: UpdateProfile :one
update profiles
set name       = coalesce(sqlc.narg('name'), name),
    avatar     = coalesce(sqlc.narg('avatar'), avatar),
    about      = coalesce(sqlc.narg('about'), about),
    dob        = coalesce(sqlc.narg('dob'), dob),
    phone      = coalesce(sqlc.narg('phone'), phone),
    updated_at = now(),
    updated_by = @updated_by
where id = @id
  and user_id = @user_id
  and updated_at = @updated_at::timestamptz
  and (coalesce(sqlc.narg('name'), name),
       coalesce(sqlc.narg('avatar'), avatar),
       coalesce(sqlc.narg('about'), about),
       coalesce(sqlc.narg('dob'), dob),
       coalesce(sqlc.narg('phone'), phone) is distinct from (name, avatar, about, dob, phone))
returning *;

-- name: Profile :one
select *
from profiles
where user_id = @user_id;