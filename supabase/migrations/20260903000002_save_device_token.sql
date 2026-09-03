create or replace function public.save_device_token(p_token text)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.device_tokens (token, user_id)
  values (p_token, auth.uid())
  on conflict (token) do update
    set user_id = excluded.user_id;
end;
$$;
revoke execute on function public.save_device_token(text) from anon;