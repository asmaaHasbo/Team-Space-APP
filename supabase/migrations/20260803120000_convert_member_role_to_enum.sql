-- space_members.role started as plain text and was later converted to an
-- enum so the DB itself rejects an invalid role.
create type public.member_role as enum ('owner', 'admin', 'member');

alter table public.space_members
  alter column role drop default,
  alter column role type public.member_role using role::public.member_role,
  alter column role set default 'member';