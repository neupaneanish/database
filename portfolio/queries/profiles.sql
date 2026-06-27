-- name: CreateProfile :execresult
insert into profiles (user_id, name, headline, dob, created_by, updated_by)
values (@user_id, @name, @headline, @dob, @created_by, @updated_by);

-- name: UpdateProfile :one
update profiles
set headline   = @headline,
    updated_at = now(),
    updated_by = @updated_by
where user_id = @user_id
  and updated_at = @updated_at::timestamptz
  and headline is distinct from @headline
returning *;

-- name: Profile :one
select *
from profiles
where user_id = @user_id;