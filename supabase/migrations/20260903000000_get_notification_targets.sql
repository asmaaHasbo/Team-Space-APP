-- Who gets notified for a new message: every member of the chat except the
-- sender, minus anyone already looking at it. The sender's name rides along
-- so the Edge Function needs only one round trip.
drop function if exists public.get_notification_targets(uuid, uuid, timestamptz);

create function public.get_notification_targets(
  p_chat_id uuid,
  p_sender_id uuid,
  p_sent_at timestamptz
)
returns table (token text, sender_name text)
language sql
security definer
set search_path = public
as $$
  select dt.token, p.full_name
  from chat_members cm
  join device_tokens dt on dt.user_id = cm.user_id
  -- left join: a missing profile must not wipe out the token rows
  left join profiles p on p.id = p_sender_id
  where cm.chat_id = p_chat_id
    and cm.user_id <> p_sender_id
    -- null means they never opened this chat at all
    and (cm.last_read_at is null or cm.last_read_at < p_sent_at);
$$;

-- This one filters by its parameters, not by auth.uid(), so it protects
-- nothing on its own. Only the server may call it.
revoke execute on function public.get_notification_targets(uuid, uuid, timestamptz)
  from anon, authenticated;