-- name: CreateDomain :one
insert into domains (user_id, nameserver_id, fqdn, txt, created_by, updated_by)
values (@user_id, @nameserver_id, @fqdn, @txt, @created_by, @updated_by)
returning id;

-- name: VerifyDomain :execrows
update domains
set verified_at = now(),
    updated_at  = now(),
    updated_by  = @updated_by
where id = @id
  and user_id = @user_id
  and verified_at is null
  and updated_at = @updated_at::timestamptz;

-- name: Domain :one
select d.id, d.fqdn, d.txt, ns.ip_type, ns.ip, d.updated_at
from domains d
         inner join nameservers ns on ns.id = d.nameserver_id
where d.id = @id
  and d.user_id = @user_id
  and d.verified_at is null;

-- name: Domains :many
select d.id,
       d.user_id,
       d.txt,
       d.fqdn,
       ns.ip_type,
       ns.ip,
       (d.verified_at is not null)::boolean as verified,
       d.created_at,
       d.created_by,
       d.updated_at,
       d.updated_by
from domains d
         inner join nameservers ns on ns.id = d.nameserver_id
where user_id = @user_id
order by d.fqdn;

-- name: DeleteDomain :execrows
delete
from domains
where id = @id
  and user_id = @user_id
  and updated_at = @updated_at::timestamptz;