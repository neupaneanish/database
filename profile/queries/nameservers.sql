-- name: CreateNameServer :one
insert into nameservers(domain, cname, created_by, updated_by)
values (@domain, @cname, @created_by, @updated_by)
returning id;

-- name: NameServers :many
select *
from nameservers
order by created_at desc;

-- name: NameServer :one
select id
from nameservers
where active = true
order by random()
limit 1;

-- name: UpdateNameServer :execresult
update nameservers
set domain = @domain,
    cname  = @cname,
    active = @active
where id = @id
  and updated_at = @updated_at::timestamptz
  and (domain, cname, active) is distinct from (@domain, @cname, @active);

-- name: DeleteNameServer :execresult
delete
from nameservers
where id = @id
  and updated_at = @updated_at::timestamptz;