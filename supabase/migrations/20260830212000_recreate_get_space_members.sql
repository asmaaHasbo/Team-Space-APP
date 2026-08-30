-- get_space_members was declared as returning `role text`, but space_members.role
-- became the `member_role` enum in 20260803120000 — postgres rejected every call
-- with 42804 "structure of query does not match function result type".
--
-- The declaration now names the enum itself, and `email` joins the result so a
-- member's profile screen can show it. Return types cannot be changed in place,
-- hence the drop.

drop function if exists public.get_space_members(uuid);

create function public.get_space_members(p_space_id uuid)
 returns table(
   user_id    uuid,
   full_name  text,
   email      text,
   avatar_url text,
   role       member_role
 )
 language plpgsql
 security definer
 set search_path to 'public'
as $function$
begin
  -- security definer bypasses RLS, so membership is checked by hand
  if not public.is_space_member(p_space_id) then
    raise exception 'not a member of this space';
  end if;

  return query
  select
    sm.user_id,
    p.full_name,
    p.email,
    p.avatar_url,
    sm.role
  from space_members sm
  join profiles p on p.id = sm.user_id
  where sm.space_id = p_space_id
    and p.deleted_at is null
  order by p.full_name;
end;
$function$;

grant execute on function public.get_space_members(uuid) to authenticated;
