-- Applied live via the Supabase SQL Editor. This file documents it for a fresh DB.
-- Run AFTER create_spaces_and_members and BEFORE chat_rls_and_functions, which
-- is the first migration to call it.
--
-- Every security definer function that reads a space has to answer the same
-- question first: is the caller actually in this space? RLS is off inside those
-- functions, so the check cannot be left to a policy.
--
-- stable = same answer within one statement, so postgres may call it once
-- instead of once per row.

create or replace function public.is_space_member(p_space_id uuid)
 returns boolean
 language sql
 stable
 security definer
 set search_path to 'public'
as $function$
  select exists (
    select 1
    from space_members
    where space_id = p_space_id
      and user_id = auth.uid()
  );
$function$;

grant execute on function public.is_space_member(uuid) to authenticated;
