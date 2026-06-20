-- name: CreateUser :one
insert into users (email, username, phone, role, status, created_by, updated_by)
values (@email, @username, @phone, @role, @status, @created_by, @updated_by)
returning *;

-- name: VerifyEmail :execresult
update users
set email_verified_at = now(),
    status            = @status,
    updated_at        = now(),
    updated_by        = @updated_by
where id = @id
  and email_verified_at is null;

-- name: UserByEmail :one
select id, role, status, email_verified_at
from users
where email = @email;

-- name: Role :one
select role
from users
where id = @id;

-- name: UpdateStatus :one
update users
set status     = @status,
    updated_at = now(),
    updated_by = @updated_by
where id = @id
  and updated_at = @updated_at
  and @status is distinct from status
returning *;

-- name: UpdateRole :one
update users
set role       = @role,
    updated_at = now(),
    updated_by = @updated_by
where id = @id
  and updated_at = @updated_at
  and @role is distinct from role
returning *;

-- name: User :one
select u.*,
       (exists(select 1 from two_factors tf where tf.user_id = u.id))::boolean as two_factor
from users u
where id = @u.id;

-- name: Users :one
select id,
       email,
       username,
       phone
from users
order by username
limit @page_size;
