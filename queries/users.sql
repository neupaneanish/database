-- name: CreateUser :one
insert into users (email, username, role, status, email_verified_at, created_by, updated_by)
values (@email, @username, @role, @status, now(), @created_by, @updated_by)
returning *;

-- name: VerifyEmail :one
update users
set email_verified_at = now(),
    updated_at        = now(),
    updated_by        = @updated_by
where id = @id
  and email_verified_at is null
returning *;

-- name: UserByEmail :one
select *
from users
where email = @email;

-- name: Me :one
select role, email_verified_at
from users
where id = @id;

-- name: UpdateUser :one
update users
set username          = coalesce(sqlc.narg('username'), username),
    email             = coalesce(sqlc.narg('email'), email),
    role              = coalesce(sqlc.narg('role'), role),
    status            = coalesce(sqlc.narg('status'), status),
    email_verified_at = case
                            when coalesce(sqlc.narg('email'), email) is distinct from email then null
                            else email_verified_at end,
    updated_at        = now(),
    updated_by        = @updated_by
where id = @id
  and updated_at = @updated_at::timestamptz
  and (coalesce(sqlc.narg('username'), username),
       coalesce(sqlc.narg('email'), email),
       coalesce(sqlc.narg('role'), role),
       coalesce(sqlc.narg('status'), status) is distinct from (username, email, role, status))
returning *;

-- name: User :one
select u.*,
       p.name,
       p.avatar,
       p.phone,
       (exists(select 1 from two_factors tf where tf.user_id = u.id))::boolean as two_factor
from users u
         join profiles p on u.id = p.user_id
where u.id = @id;

-- name: Users :one
select u.id,
       u.email,
       u.username,
       p.name,
       p.avatar
from users u
         join profiles p on u.id = p.user_id
order by p.name, u.id
limit @page_size;
