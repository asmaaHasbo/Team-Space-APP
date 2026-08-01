create table spaces (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  invite_code text not null unique,
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now()
);

create table space_members (
  space_id uuid not null references spaces(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role text not null default 'member',
  joined_at timestamptz not null default now(),
  primary key (space_id, user_id)
);

alter table spaces enable row level security;
alter table space_members enable row level security;

-- 1. space_members: كل واحد يشوف عضوياته بس
create policy "members can view own memberships"
on space_members for select
to authenticated
using (user_id = auth.uid());

-- 2. spaces: كل واحد يشوف الـ spaces اللي هو عضو فيها
create policy "members can view their spaces"
on spaces for select
to authenticated
using (
  id in (
    select space_id from space_members
    where user_id = auth.uid()
  )
);

-- 3. space_members: كل واحد يضيف عضوية لنفسه بس
create policy "users can add their own membership"
on space_members for insert
to authenticated
with check (user_id = auth.uid());

-- 4. spaces: كل واحد يعمل space باسمه هو
create policy "users can create spaces"
on spaces for insert
to authenticated
with check (created_by = auth.uid());