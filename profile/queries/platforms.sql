-- name: CreatePlatform :one
insert into platforms (name, url, logo_url, color, url_suffix, created_by, updated_by)
values (@name, @url, @logo_url, @color, @url_suffix, @created_by, @updated_by)
returning id;

-- name: UpdatePlatform :one
update platforms
set name       = @name,
    url        = @url,
    logo_url   = @logo_url,
    color      = @color,
    url_suffix = @url_suffix,
    updated_at = now(),
    updated_by = @updated_by
where id = @id
  and updated_at = @updated_at::timestamptz
  and (name, url, logo_url, color, url_suffix) is distinct from (@name, @url, @logo_url, @color, @url_suffix)
returning id;

-- name: Platform :one
select *
from platforms
where id = @id;

-- name: Platforms :many
select id, name, logo_url, color, url_suffix
from platforms
order by name;

-- name: DeletePlatform :execresult
delete
from platforms
where id = @id;