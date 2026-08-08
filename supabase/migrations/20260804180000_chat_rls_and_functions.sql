-- Default-chat marker, automatic General chat, and join-by-code RPC.
-- Applied live via the Supabase SQL Editor. This file documents them for a fresh DB.
-- Run AFTER create_chat_tables and the chat functions/RLS migration.

-- =========================================================
-- 1. is_default on chats
-- =========================================================

-- Marks the space's built-in chat explicitly.
-- Looking it up by name = 'General' would break the day the chat is renamed,
-- localised, or duplicated by a user-created group with the same name:
-- a name is display data, not identity.

alter table public.chats
add column if not exists is_default boolean not null default false;

-- One-time backfill. The column arrives as false for every existing row,
-- so the General chats created before it existed would look non-default.
-- Matching on the name is acceptable here only because these rows were all
-- produced by create_space_with_owner and nothing else is named 'General' yet.

update public.chats
set is_default = true
where name = 'General' and type = 'group';

-- =========================================================
-- 2. create_space_with_owner -> now provisions the General chat
-- =========================================================

-- Everything a new space needs, in one transaction: the space row, the
-- owner's membership, the default group chat, and the owner inside it.
-- If any statement fails the whole thing rolls back, so a space can never
-- end up half-built (an "orphan" space with no members is invisible to
-- everyone, including the person who created it).
--
-- security definer matters twice here:
--   - chat_members has no INSERT policy at all, on purpose, so that nobody
--     can add themselves to a private conversation from the client.
--     RLS is off inside the function, so this insert is allowed.
--   - the function only ever writes rows for auth.uid(), never for an id
--     supplied by the caller.
--
-- The signature and the return type are unchanged, so the Flutter side
-- keeps calling it exactly as before.

create or replace function public.create_space_with_owner(space_name text)
returns spaces
language plpgsql
security definer
set search_path = public
as $$
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
$$;

-- =========================================================
-- 3. join_space_by_code
-- =========================================================

-- Replaces the old client-side flow (select the space by code, then upsert
-- the membership), which could never work: the SELECT policy on spaces only
-- exposes spaces you are already a member of, so someone joining could not
-- see the space they were joining. The lookup returned zero rows and the app
-- reported "Invalid invite code" for a perfectly valid code.
--
-- security definer removes that block, and the membership insert is what
-- makes the space genuinely visible afterwards - the policy is unchanged,
-- the user simply satisfies it now.

create or replace function public.join_space_by_code(p_invite_code text)
returns spaces
language plpgsql
security definer
set search_path = public
as $$
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
  -- the app, where it belongs; a raised exception would surface to the user
  -- as a raw Postgres message.
  if target_space.id is null then
    return null;
  end if;

  -- on conflict do nothing: re-joining a space you are already in should
  -- simply let you in, not fail on the composite primary key. It also stops
  -- an existing admin row from being demoted back to 'member'.
  insert into space_members (space_id, user_id, role)
  values (target_space.id, auth.uid(), 'member')
  on conflict do nothing;

  select id into general_chat_id
  from chats
  where space_id = target_space.id
    and is_default = true
    and deleted_at is null;

  -- Guarded on purpose: a space with no default chat should still let people
  -- join. Getting into the space is the point; the chat is a bonus.
  if general_chat_id is not null then
    insert into chat_members (chat_id, user_id)
    values (general_chat_id, auth.uid())
    on conflict do nothing;
  end if;

  return target_space;
end;
$$;