-- name: CreateUser :one
insert into users (email, username, phone, role, status, created_by, updated_by)
values (@email, @username, @phone, @role, @status, @created_by, @updated_by)
returning id, email, username, role;

-- name: VerifyEmail :execrows
update users
set email_verified_at = now(),
    status            = @status,
    updated_at        = now(),
    updated_by        = @updated_by
where id = @id
  and email_verified_at is null;

-- name: UserByEmail :one
select id, email, username, role, status, email_verified_at
from users
where email = @email;

-- name: Role :one
select role
from users
where id = @id;

-- name: UpdateRole :execrows
update users
set role       = @role,
    updated_at = now(),
    updated_by = @updated_by
where id = @id
  and updated_at = @updated_at
  and role is distinct from @role;

-- name: UpdateStatus :execrows
update users
set status     = @status,
    updated_at = now(),
    updated_by = @updated_by
where id = @id
  and updated_at = @updated_at
  and status is distinct from @status;

-- name: UpdateUsername :execrows
update users
set username   = @username,
    updated_at = now(),
    updated_by = @updated_by
where id = @id
  and updated_at = @updated_at
  and username is distinct from @username;

-- name: UpdateEmail :execrows
update users
set email             = @email,
    updated_at        = now(),
    updated_by        = @updated_by,
    email_verified_at = null
where id = @id
  and email is distinct from @email;

-- name: User :one
select u.id,
       u.email,
       u.username,
       u.phone,
       u.role,
       u.status,
       (u.email_verified_at is not null)::boolean                              as email_verified,
       u.email_verified_at,
       (u.phone_verified_at is not null)::boolean                              as phone_verified,
       u.phone_verified_at,
       u.created_at,
       u.created_by,
       u.updated_at,
       u.updated_by,
       (exists(select 1 from two_factors tf where tf.user_id = u.id))::boolean as two_factor,
       c.created_at::timestamptz                                               as last_password_updated_at
from users u
         join lateral ( select c.created_at
                        from credentials c
                        where c.user_id = u.id
                        order by c.id desc
                        limit 1) as c on true
where u.id = @id;

-- name: Users :many
select id,
       email,
       (email_verified_at is not null)::boolean as email_verified,
       username,
       phone,
       (phone_verified_at is not null)::boolean as phone_verified
from users
order by username
limit @page_size;
