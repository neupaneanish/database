-- name: Login :one
select u.id,
       u.email,
       u.email_verified_at,
       u.username,
       u.role,
       u.status,
       c.password,
       (exists(select 1 from two_factors tf where tf.user_id = u.id))::boolean as two_factor
from users u
         join lateral ( select c.password
                        from credentials c
                        where u.id = c.user_id
                        order by c.id desc
                        limit 1) as c on true
where email = @email
limit 1;