
-- profiles = public mirror of auth.users
-- Every other table references profiles.id, never auth.users.id.
-- =============================================================================


-- -----------------------------------------------------------------------------
-- 1) Table
-- -----------------------------------------------------------------------------
create table if not exists public.profiles (
    id          uuid        primary key references auth.users (id) on delete cascade,
    email       text        not null,
    full_name   text        not null,
    avatar_url  text,
    created_at  timestamptz not null default now(),
    updated_at  timestamptz not null default now(),
    deleted_at  timestamptz
);

-- used by the sync query: "give me everything changed since my last sync"
create index if not exists profiles_updated_at_idx
    on public.profiles (updated_at);


-- -----------------------------------------------------------------------------
-- 2) updated_at auto-touch
-- -----------------------------------------------------------------------------
create or replace function public.touch_updated_at()
returns trigger
language plpgsql
as $$
begin
    new.updated_at = now();
    return new;
end;
$$;

drop trigger if exists profiles_touch_updated_at on public.profiles;
create trigger profiles_touch_updated_at
    before update on public.profiles
    for each row
    execute function public.touch_updated_at();


-- -----------------------------------------------------------------------------
-- 3) auth.users -> profiles
-- -----------------------------------------------------------------------------
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer          -- runs as the owner, not as supabase_auth_admin
set search_path = ''      -- mandatory with security definer
as $$
begin
    insert into public.profiles (id, email, full_name, avatar_url)
    values (
        new.id,
        new.email,
        coalesce(
            nullif(new.raw_user_meta_data ->> 'full_name', ''),
            split_part(new.email, '@', 1)
        ),
        new.raw_user_meta_data ->> 'avatar_url'
    )
    on conflict (id) do nothing;   -- any error here kills the whole signup

    return new;
end;
$$;

revoke all on function public.handle_new_user() from public, anon, authenticated;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
    after insert on auth.users
    for each row
    execute function public.handle_new_user();


-- -----------------------------------------------------------------------------
-- 4) Security
--    grant  = may this role touch the table at all?   -> permission denied
--    policy = which rows exactly?                      -> silently empty
-- -----------------------------------------------------------------------------
alter table public.profiles enable row level security;

grant select, update on public.profiles to authenticated;

drop policy if exists "profiles_select_authenticated" on public.profiles;
create policy "profiles_select_authenticated"
    on public.profiles
    for select
    to authenticated
    using (deleted_at is null);

drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own"
    on public.profiles
    for update
    to authenticated
    using (auth.uid() = id)
    with check (auth.uid() = id);

-- No insert policy -> only the trigger creates profiles.
-- No delete policy -> deletion happens via the auth.users cascade.