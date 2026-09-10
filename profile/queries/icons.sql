-- name: CreateIcon :exec
insert into icons (name, site, site_suffix, url, slug, variant, color, created_by, updated_by)
values (@name, @site, @site_suffix, @url, @slug, @variant, @color, @created_by, @updated_by);

-- name: UpdateIcon :execrows
update icons
set name        = @name,
    site        = @site,
    site_suffix = @site_suffix,
    url         = @url,
    slug        = @slug,
    variant     = @variant,
    color       = @color
where id = @id
  and updated_at = @updated_at::timestamptz
  and (name, site, site_suffix, url, slug, variant, color) is distinct from (@name, @site, @site_suffix, @url, @slug, @variant, @color);

-- name: Icon :one
select id,
       name,
       site,
       site_suffix,
       url,
       slug,
       variant,
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
       concat('https://', url, '/', slug) as url
from icons
order by name;