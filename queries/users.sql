-- name: CreateUser :one
insert into users (email, username, role, status, created_by, updated_by)
values (@email, @username, @role, @status, @created_by, @updated_by)
returning *;

-- name: VerifyEmail :one
update users
set email_verified_at = now(),
    updated_at        = now(),
    updated_by        = @updated_by
where id = @id
  and email_verified_at is null
returning *;

-- name: UserByUsername :one
select *
from users
where username = @username;

-- name: Me :one
select role, email_verified_at
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
