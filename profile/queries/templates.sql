-- name: CreateTemplate :one
insert into templates (icon_id, name, description, created_by, updated_by)
values (@icon_id, @name, @description, @created_by, @updated_by)
returning id;

-- name: UpdateTemplate :one
update templates
set name        = @name,
    icon_id     = @icon_id,
    description = @description,
    updated_at  = now(),
    updated_by  = @updated_by
where id = @id
  and updated_at = @updated_at::timestamptz
  and (name, icon_id, description) is distinct from (@name, @icon_id, @description)
returning id, name;

-- name: Template :one
select t.*, concat('https://', hostname, '/', suffix)::text as icon
from templates t
         join icons i on i.id = t.icon_id
where t.id = @id;

-- name: Templates :many
select t.id,
       t.name,
       t.description,
       concat('https://', i.hostname, '/', i.suffix)::text as icon
from templates t
         join icons i on i.id = t.icon_id
order by t.name;

-- name: TemplateIcons :many
select id,
       name,
       concat('https://', hostname, '/', suffix)::text as icon
from icons
where site_suffix is null
order by name;

-- name: DeleteTemplate :execrows
delete
from templates
where id = @id
  and updated_at = @updated_at::timestamptz;
