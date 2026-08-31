alter table messages
alter column created_by set default auth.uid();