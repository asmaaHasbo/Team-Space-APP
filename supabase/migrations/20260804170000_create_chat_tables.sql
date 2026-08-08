-- Chat layer: chat_type enum + chats + chat_members + messages
-- Applied live via the Supabase Table Editor. This file documents the schema for a fresh DB.

create type public.chat_type as enum ('direct', 'group');

create table public.chats (
  id uuid primary key default gen_random_uuid(),
  space_id uuid not null references public.spaces (id) on delete cascade,
  type public.chat_type not null,
  name text,
  dm_key text unique,
  created_by uuid references auth.users (id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create table public.chat_members (
  chat_id uuid not null references public.chats (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  last_read_at timestamptz,
  created_at timestamptz not null default now(),
  primary key (chat_id, user_id)
);

create table public.messages (
  id uuid primary key default gen_random_uuid(),
  chat_id uuid not null references public.chats (id) on delete cascade,
  created_by uuid references auth.users (id) on delete set null,
  message_content text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);