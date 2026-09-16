-- name: CreateProfile :exec
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

-- name: Exists :one
select exists(select 1
              from profiles
              where user_id = @user_id) as profile,
       exists(select 1
              from abouts
              where user_id = @user_id) as about,
       exists(select 1
              from educations
              where user_id = @user_id) as educations,
       exists(select 1
              from experiences
              where user_id = @user_id) as experiences,
       exists(select 1
              from socials
              where user_id = @user_id) as socials;