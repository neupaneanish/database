-- name: CreateNameServer :one
insert into name_servers(domain, cname, created_by, updated_by)
values (@domain, @cname, @created_by, @updated_by)
returning id;

-- name: NameServers :many
select *
from name_servers
order by created_at desc;

-- name: NameServer :one
select id
from name_servers
where active = true
order by random()
limit 1;

-- name: UpdateNameServer :one
update name_servers
set domain = @domain,
    cname  = @cname,
    active = @active
where id = @id
  and updated_at = @updated_at::timestamptz
returning id;

-- name: DeleteNameServer :execresult
delete
from name_servers
where id = @id
  and updated_at = @updated_at::timestamptz;