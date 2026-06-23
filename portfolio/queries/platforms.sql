-- name: CreatePlatform :one
insert into platforms (name, url, logo_url, color, created_by, updated_by)
values (@name, @url, @logo_url, @color, @created_by, @updated_by)
returning *;

-- name: UpdatePlatform :one
update platforms
set name       = coalesce(sqlc.narg('name'), name),
    url        = coalesce(sqlc.narg('url'), url),
    logo_url   = coalesce(sqlc.narg('logo_url'), logo_url),
    color      = coalesce(sqlc.narg('color'), color),
    updated_at = now(),
    updated_by = @updated_by
where id = @id
  and updated_at = @updated_at::timestamptz
returning *;

-- name: Platform :one
select *
from platforms
where id = @id;

-- name: Platforms :many
select *
from platforms
order by name;

-- name: DeletePlatform :execresult
delete
from platforms
where id = @id;