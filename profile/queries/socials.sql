-- name: CreateSocial :one
insert into socials (user_id, icon_id, username, created_by, updated_by)
values (@user_id, @icon_id, @username, @created_by, @updated_by)
returning id;

-- name: UpdateSocial :execrows
update socials
set username   = @username,
    updated_at = now(),
    updated_by = @updated_by
where id = @id
  and user_id = @user_id
  and updated_at = @updated_at::timestamptz
  and username is distinct from @username;

-- name: Social :one
select s.*, concat('https://', i.hostname, '/', i.suffix)::text as icon
from socials s
         join icons i on s.icon_id = i.id
where s.id = @id
  and s.user_id = @user_id;

-- name: Socials :many
select s.id,
       s.user_id,
       s.icon_id,
       s.username,
       s.updated_at,
       i.name,
       concat('https://', i.site_hostname, i.site_suffix, s.username)::text as social,
       concat('https://', i.hostname, '/', i.suffix)::text                  as icon
from socials s
         join icons i on s.icon_id = i.id
where s.user_id = @user_id
  and i.site_suffix is not null
order by i.name;

-- name: SocialIcons :many
select i.id,
       i.name,
       concat('https://', i.hostname, '/', i.suffix)::text as icon
from icons i
         left join socials s on s.icon_id = i.id and s.user_id = @user_id
where i.site_suffix is not null
  and s.id is null
order by i.name;

-- name: DeleteSocial :execrows
delete
from socials
where id = @id
  and user_id = @user_id
  and updated_at = @updated_at::timestamptz;
