-- name: CreateTwoFactor :execresult
insert into two_factors (user_id, secret, created_by, updated_by)
values (@user_id, @secret, @created_by, @updated_by);

-- name: TwoFactorSecret :one
select secret
from two_factors
where user_id = @user_id;

-- name: UpdateTwoFactor :execresult
update two_factors
set last_used_at = now(),
    updated_at   = now(),
    updated_by   = @updated_by
where user_id = @user_id;

-- name: DeleteTwoFactor :execresult
delete
from two_factors
where user_id = @user_id;