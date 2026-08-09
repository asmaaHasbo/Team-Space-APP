-- is_default: an explicit DB-level marker for the space's default chat.
-- A NAME is display data, never identity.
alter table public.chats
  add column if not exists is_default boolean not null default false;

-- One-time backfill for spaces created before the column existed.
update public.chats
set is_default = true
where name = 'General'
  and type = 'group';


CREATE OR REPLACE FUNCTION public.create_space_with_owner(space_name text)
 RETURNS spaces
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  new_space spaces;
  new_chat_id uuid;
begin
  insert into spaces (name, created_by)
  values (space_name, auth.uid())
  returning * into new_space;

  insert into space_members (space_id, user_id, role)
  values (new_space.id, auth.uid(), 'owner');

  -- dm_key is left null: it only identifies direct chats, and Postgres
  -- treats NULLs as distinct under a UNIQUE constraint, so every group
  -- can share it. A '' default would have blocked the second group.
  -- chats must be inserted before chat_members - the FK on chat_id
  -- requires the chat row to exist first.
  insert into chats (space_id, type, name, created_by, is_default)
  values (new_space.id, 'group', 'General', auth.uid(), true)
  returning id into new_chat_id;

  insert into chat_members (chat_id, user_id)
  values (new_chat_id, auth.uid());

  return new_space;
end;
$function$;


CREATE OR REPLACE FUNCTION public.join_space_by_code(p_invite_code text)
 RETURNS spaces
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  target_space spaces;
  general_chat_id uuid;
begin
  select * into target_space
  from spaces
  where invite_code = p_invite_code;

  -- Compare the primary key, not the whole row: row-vs-null comparison in
  -- Postgres does not behave the way it reads.
  -- Returning null rather than raising keeps the wording of the error in
  -- the app, where it belongs.
  if target_space.id is null then
    return null;
  end if;

  -- on conflict do nothing: re-joining a space you are already in should
  -- simply let you in, not fail on the composite primary key. It also stops
  -- an existing admin row from being demoted back to 'member'.
  insert into space_members (space_id, user_id, role)
  values (target_space.id, auth.uid(), 'member')
  on conflict do nothing;