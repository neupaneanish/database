-- name: CreateDomain :one
insert into domains (user_id, nameserver_id, fqdn, txt, created_by, updated_by)
values (@user_id, @nameserver_id, @fqdn, @txt, @created_by, @updated_by)
returning id;

-- name: VerifyDomain :execresult
update domains
set verified_at = now(),
    updated_at  = now(),
    updated_by  = @updated_by
where id = @id
  and user_id = @user_id
  and verified_at is null
  and updated_at = @updated_at::timestamptz;

-- name: Domain :one
select d.txt, concat(ns.cname, '.', ns.domain)::text as nameserver
from domains d
         inner join nameservers ns on ns.id = d.name_server_id
where d.id = @id
  and d.user_id = @user_id
  and d.verified_at is null;

-- name: Domains :many
select d.id,
       d.user_id,
       d.txt,
       d.fqdn,
       concat(ns.cname, '.', ns.domain)::text as nameserver,
       (d.verified_at is not null)::boolean   as verified,
       d.created_at,
       d.created_by,
       d.updated_at,
       d.updated_by
from domains d
         inner join nameservers ns on ns.id = d.name_server_id
where user_id = @user_id
order by d.fqdn;

-- name: DeleteDomain :execresult
delete
from domains
where id = @id
  and user_id = @user_id
  and updated_at = @updated_at::timestamptz;