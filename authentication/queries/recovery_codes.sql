-- name: CreateRecoveryCodes :copyfrom
insert into recovery_codes(user_id, code, created_by, updated_by)
values (@user_id, @code, @created_by, @updated_by);

-- name: UpdateRecoveryCode :execresult
update recovery_codes
set used_at = now()
where id = @id
  and user_id = @user_id
  and used_at is null;

-- name: RecoveryCodes :many
select id, code
from recovery_codes
where user_id = @user_id
  and used_at is null;

-- name: RecoveryCodeCount :one
select count(*)
from recovery_codes
where user_id = @user_id
  and used_at is null;

-- name: DeleteRecoveryCodes :execresult
delete
from recovery_codes
where user_id = @user_id;