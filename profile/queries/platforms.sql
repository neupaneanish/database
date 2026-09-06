-- name: CreatePlatform :one
insert into platforms (name, url, url_suffix, logo_url, logo_url_suffix, logo_url_path, color, created_by, updated_by)
values (@name, @url, @url_suffix, @logo_url, @logo_url_suffix, @logo_url_path, @color, @created_by, @updated_by)
returning id;

-- name: UpdatePlatform :execresult
update platforms
set name            = @name,
    url             = @url,
    url_suffix      = @url_suffix,
    logo_url        = @logo_url,
    logo_url_suffix = @logo_url_suffix,
    logo_url_path   = @logo_url_path,
    color           = @color,
    updated_at      = now(),
    updated_by      = @updated_by
where id = @id
  and updated_at = @updated_at::timestamptz
  and (name,
       url,
       url_suffix,
       logo_url,
       logo_url_suffix,
       logo_url_path,
       color) is distinct from (
                                @name,
                                @url,
                                @url_suffix,
                                @logo_url,
                                @logo_url_suffix,
                                @logo_url_path,
                                @color);

-- name: Platform :one
select *
from platforms
where id = @id;

-- name: Platforms :many
select id,
       name,
       url,
       url_suffix,
       concat(logo_url, logo_url_suffix, logo_url_path)::text as logo,
       color
from platforms
order by name;

-- name: DeletePlatform :execresult
delete
from platforms
where id = @id;