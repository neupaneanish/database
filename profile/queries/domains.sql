-- name: CreateDomain :one
insert into domains (user_id, url, txt, created_by, updated_by)
values (@user_id, @url, @txt, @created_by, @updated_by)
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
returning id;


-- name: Domains :many
select id,
       user_id,
       txt,
       url,
       (verified_at is not null)::boolean as verified,
       created_at,
       created_by,
       updated_at,
       updated_by
from domains
where user_id = @user_id;

-- name: DeleteDomain :execresult
delete
from domains
where id = @id
  and user_id = @user_id
  and updated_at = @updated_at::timestamptz;