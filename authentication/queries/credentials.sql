-- name: CreateCredential :execresult
insert into credentials (user_id, password, created_by)
values (@user_id, @password, @created_by);

-- name: Credentials :many
select password
from credentials
where user_id = @user_id
order by id desc
limit @history_limit;