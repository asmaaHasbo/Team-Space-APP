create extension if not exists pg_net with schema extensions;

-- The dashboard webhook UI could not create this, so the hook is written by
-- hand. Same thing: an INSERT on messages calls the Edge Function.
create or replace function public.notify_on_new_message()
returns trigger
language plpgsql
security definer
set search_path = public, extensions, vault
as $$
declare
  v_key text;
begin
  select decrypted_secret into v_key
  from vault.decrypted_secrets
  where name = 'service_role_key';

  perform net.http_post(
    url := 'https://qhuuuqqnaosxzycjtuxr.supabase.co/functions/v1/send-message-notification',
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'Authorization', 'Bearer ' || v_key
    ),
    body := jsonb_build_object('record', to_jsonb(new)),
    timeout_milliseconds := 5000
  );

  return new;
end;
$$;

-- after, not before: never announce a message that failed to save.
-- insert only: her delete is a soft delete, which is an UPDATE.
create trigger on_new_message_notify
after insert on public.messages
for each row
execute function public.notify_on_new_message();