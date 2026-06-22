-- name: CreateDomain :one
insert into domains (user_id, url, txt, created_by, updated_by)
values (@user_id, @url, @txt, @created_by, @updated_by)
returning *;

-- name: VerifyDomain :one
update domains
set verified_at = now(),
    updated_at  = now(),
    updated_by  = @updated_by
where id =@id
  and user_id = @user_id
  and verified_at is null
returning *;

-- name: DeleteDomain :execresult
delete
from domains
where id = @id
  and user_id = @user_id;