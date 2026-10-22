-- device_tokens: open UPDATE/DELETE to any authenticated caller,
-- because both operations name the token itself and the token is the secret.
-- SELECT stays closed (user_id = auth.uid()) so tokens are never readable,
-- which is why the client upsert was replaced by save_device_token().

drop policy if exists device_tokens_update on public.device_tokens;

create policy device_tokens_update
on public.device_tokens
for update
to authenticated
using (true)
with check (user_id = auth.uid());

drop policy if exists device_tokens_delete on public.device_tokens;

create policy device_tokens_delete
on public.device_tokens
for delete
to authenticated
using (true);