-- name: CreateSocial :exec
insert into socials (user_id, icon_id, username, created_by, updated_by)
values (@user_id, @icon_id, @username, @created_by, @updated_by);

-- name: UpdateSocial :execrows
update socials
set username   = @username,
    updated_at = now(),
    updated_by = @updated_by
where id = @id
  and user_id = @user_id
  and updated_at = @updated_at::timestamptz
  and username is distinct from @username;

-- name: Socials :many
select s.id,
       s.user_id,
       s.icon_id,
       s.username,
       s.created_at,
       s.created_by,
       s.updated_at,
       s.updated_by,
       i.name,
       concat('https://', i.site, i.site_suffix, s.username)::text as site,
       concat('https://', i.url, '/', i.slug)::text                as logo
from socials s
         join icons i on s.icon_id = i.id
where s.user_id = @user_id
  and i.site_suffiex is not null
order by i.name;

-- name: SocialIcons :many
select i.id,
       i.name,
       concat('https://', i.url, '/', i.slug) as url
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
