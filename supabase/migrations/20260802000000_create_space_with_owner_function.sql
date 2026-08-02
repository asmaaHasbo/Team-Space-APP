-- Function: create a space and its owner membership atomically.
-- Runs both inserts as one transaction (Postgres wraps function bodies
-- in a transaction automatically), so a partial write is impossible —
-- no orphan space if the second insert fails.
-- security definer: runs with elevated rights so future stricter RLS
-- policies won't block this trusted internal write. Safe because it only
-- ever writes for auth.uid() (the calling user), never an arbitrary id.
create or replace function create_space_with_owner(space_name text)
returns spaces
language plpgsql
security definer
set search_path = public
as $$
declare
  new_space spaces;
begin
  insert into spaces (name, created_by)
  values (space_name, auth.uid())
  returning * into new_space;

  insert into space_members (space_id, user_id, role)
  values (new_space.id, auth.uid(), 'owner');

  return new_space;
end;
$$;