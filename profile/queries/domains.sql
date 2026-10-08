-- name: CreateDomain :one
insert into domains (user_id,
                     nameserver_id,
                     template_id,
                     hostname,
                     txt,
                     created_by,
                     updated_by)
values (@user_id,
        (select id
         from nameservers
         order by random()
         limit 1),
        (select id
         from templates
         order by random()
         limit 1),
        @hostname,
        @txt,
        @created_by,
        @updated_by)
returning id;

-- name: VerifyDomain :one
update domains
set verified_at = now(),
    updated_at  = now(),
    updated_by  = @updated_by
where id = @id
  and user_id = @user_id
  and verified_at is null
  and updated_at = @updated_at::timestamptz
  and txt = @txt
returning id, hostname, user_id, template_id;

-- name: UpdateDomainTemplate :one
update domains
set template_id = @template_id,
    updated_at  = now(),
    updated_by  = @updated_by
where id = @id
  and user_id = @user_id
  and verified_at is not null
  and updated_at = @updated_at::timestamptz
  and template_id is distinct from @template_id
returning id, hostname, user_id, template_id;

-- name: Domain :one
select d.id,
       d.user_id,
       d.template_id,
       t.name                                              as template,
       concat('https://', i.hostname, '/', i.suffix)::text as template_icon,
       d.hostname,
       d.txt,
       concat(ns.cname, '.', ns.hostname)::text            as nameserver,
       d.nameserver_id,
       d.verified_at,
       (d.verified_at is not null)::boolean                as verified,
       d.created_at,
       d.created_by,
       d.updated_at,
       d.updated_by
from domains d
         inner join nameservers ns on ns.id = d.nameserver_id
         inner join templates t on t.id = d.template_id
         inner join icons i on t.icon_id = i.id
where d.id = @id
  and d.user_id = @user_id;

-- name: Domains :many
select id,
       user_id,
       hostname,
       (verified_at is not null)::boolean as verified
from domains
where user_id = @user_id
order by hostname;

-- name: DeleteDomain :execrows
delete
from domains
where id = @id
  and user_id = @user_id
  and hostname = @hostname
  and updated_at = @updated_at::timestamptz;