-- name: CreateAbout :execrows
insert into abouts (user_id, about, created_by, updated_by)
values (@user_id, @about, @created_by, @updated_by);

-- name: UpdateAbout :execrows
update abouts
set about      = @about,
    updated_at = now(),
    updated_by = @updated_by
where user_id = @user_id
  and updated_at = @updated_at::timestamptz
  and about is distinct from @about;

-- name: About :one
select *
from abouts
where user_id = @user_id;