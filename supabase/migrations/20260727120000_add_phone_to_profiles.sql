
alter table public.profiles
    add column phone text not null unique
    check (phone ~ '^01[0-9]{9}$');


create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
    insert into public.profiles (id, email, full_name, phone, avatar_url)
    values (
        new.id,
        new.email,
        coalesce(
            nullif(new.raw_user_meta_data ->> 'full_name', ''),
            split_part(new.email, '@', 1)
        ),
        new.raw_user_meta_data ->> 'phone',
        new.raw_user_meta_data ->> 'avatar_url'
    )
    on conflict (id) do nothing;

    return new;
end;
$$;