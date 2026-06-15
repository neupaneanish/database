-- name: CreateProfile :one
insert into profiles(user_id, name, dob, phone, created_by, updated_by)
values (@user_id, @name, @dob, @phone, @created_by, @updated_by)
returning *;

-- name: UpdateAvatar :one
update profiles
set avatar     = @avatar,
    updated_at = now(),
    updated_by = @updated_by
where id = @id
  and user_id = @user_id
  and updated_at = @updated_at::timestamptz
returning avatar;

-- name: UpdateAbout :one
update profiles
set about      = @about,
    updated_at = now(),
    updated_by = @updated_by
where id = @id
  and user_id = @user_id
  and updated_at = @updated_at::timestamptz
returning about;

-- name: UpdatePhone :one
update profiles
set phone      = @phone,
    updated_at = now(),
    updated_by = @updated_by
where id = @id
  and user_id = @user_id
  and updated_at = @updated_at::timestamptz
returning phone;

-- name: Profile :one
select *
from profiles
where user_id = @user_id;