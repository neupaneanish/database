-- name: CreateNameserver :one
insert into nameservers(cname, hostname, created_by, updated_by)
values (@cname, @hostname, @created_by, @updated_by)
returning id;

-- name: Nameservers :many
select id, concat(cname, '.', hostname):: text as server
from nameservers
order by hostname;

-- name: Nameserver :one
select *
from nameservers
where id = @id;

-- name: DeleteNameserver :execrows
delete
from nameservers
where id = @id
  and updated_at = @updated_at::timestamptz;