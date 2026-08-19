create or replace function shares_space_with(p_user_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from space_members mine
    join space_members theirs
      on theirs.space_id = mine.space_id
    where mine.user_id = auth.uid()
      and theirs.user_id = p_user_id
  );
$$;



alter policy "profiles_select_authenticated"
on "public"."profiles"
to authenticated
using (
  deleted_at is null
  and (
    id = auth.uid()
    or shares_space_with(id)
  )
);