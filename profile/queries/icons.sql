-- name: CreateIcon :one
insert into icons (name, site_hostname, site_suffix, hostname, suffix, color, created_by, updated_by)
values (@name, @site_hostname, @site_suffix, @hostname, @suffix, @color, @created_by, @updated_by)
returning id;

-- name: UpdateIcon :execrows
update icons
set name          = @name,
    site_hostname = @site_hostname,
    site_suffix   = @site_suffix,
    hostname      = @hostname,
    suffix          = @suffix,
    color         = @color
where id = @id
  and updated_at = @updated_at::timestamptz
  and (name, site_hostname, site_suffix, hostname, slug, color) is distinct from (@name, @site_hostname, @site_suffix, @hostname, @suffix, @color);

-- name: Icon :one
select id,
       name,
       site_hostname,
       site_suffix,
       hostname,
       suffix,
       color,
       created_at,
       created_by,
       updated_at,
       updated_by
from icons
where id = @id;

-- name: DeleteIcon :execrows
delete
from icons
where id = @id
  and updated_at = @updated_at::timestamptz;

-- name: Icons :many
select id,
       name,
       concat('https://', hostname, '/', suffix)::text as icon
from icons
order by name;