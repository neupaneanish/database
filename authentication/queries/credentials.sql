-- name: CreateCredential :execresult
insert into credentials (user_id, password, created_by)
values (@user_id, @password, @created_by);

-- name: Credentials :many
select password
from credentials
where user_id = @user_id
order by id desc
limit @history_limit;

-- name: Credential :one
select c.password, u.email
from credentials c
         join public.users u on c.user_id = u.id
where user_id = @user_id
order by c.id desc
limit 1;