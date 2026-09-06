-- name: CreateDomain :one
insert into domains (user_id, name_server_id, fqdn, txt, created_by, updated_by)
values (@user_id, @name_server_id, @fqdn, @txt, @created_by, @updated_by)
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


-- name: Domains :many
select d.id,
       d.user_id,
       d.txt,
       d.fqdn,
       concat(ns.cname, '.', ns.domain)::text as name_server,
       (d.verified_at is not null)::boolean   as verified,
       d.created_at,
       d.created_by,
       d.updated_at,
       d.updated_by
from domains d
         inner join name_servers ns on ns.id = d.name_server_id
where user_id = @user_id;

-- name: DeleteDomain :execresult
delete
from domains
where id = @id
  and user_id = @user_id
  and updated_at = @updated_at::timestamptz;