-- name: CreateSocial :one
insert into socials (user_id, platform_id, username, created_by, updated_by)
values (@user_id, @platform_id, @username, @created_by, @updated_by)
returning *;

-- name: UpdateSocial :one
update socials
set username   = @username,
    updated_at = now(),
    updated_by = @updated_by
where id = @id
  and user_id = @user_id
  and updated_at = @updated_at::timestamptz
  and username is distinct from @username
returning *;

-- name: Socials :many
select s.id,
       s.user_id,
       s.username,
       s.created_at,
       s.created_by,
       s.updated_at,
       s.updated_by,
       p.name,
       p.url,
       p.logo_url,
       p.color
from socials s
         join platforms p on s.platform_id = p.id
where s.user_id = @user_id
order by p.name;

-- name: DeleteSocial :execresult
delete
from socials
where id = @id
  and user_id = @user_id
  and updated_at = @updated_at::timestamptz;