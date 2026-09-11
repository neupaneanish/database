-- name: CreateNameserver :one
insert into nameservers(ip, ip_type, created_by, updated_by)
values (@ip, @ip_type, @created_by, @updated_by)
returning id;

-- name: Nameservers :many
select *
from nameservers
order by created_at desc;

-- name: Nameserver :one
select id
from nameservers
order by random()
limit 1;

-- name: DeleteNameserver :execrows
delete
from nameservers
where id = @id
  and updated_at = @updated_at::timestamptz;