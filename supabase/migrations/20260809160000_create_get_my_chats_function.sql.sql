create or replace function get_my_chats(p_space_id uuid)
returns table (
  id uuid,
  type chat_type,
  name text,
  is_default boolean,
  display_name text,
  avatar_url text,
  last_message text,
  last_message_at timestamptz,
  unread_count bigint
)
language sql
security definer
set search_path = public
as $$
  SELECT
    c.id,
    c.type,
    c.name,
    c.is_default,
    CASE
      WHEN c.type = 'group' THEN c.name
      ELSE p.full_name
    END AS display_name,
    CASE
      WHEN c.type = 'direct' THEN p.avatar_url
      ELSE NULL
    END AS avatar_url,
    last_msg.message_content AS last_message,
    last_msg.created_at AS last_message_at,
    (
      SELECT COUNT(*)
      FROM messages m
      WHERE m.chat_id = c.id
        AND m.deleted_at IS NULL
        AND m.created_by IS DISTINCT FROM auth.uid()
        AND m.created_at > COALESCE(me.last_read_at, 'epoch')
    ) AS unread_count
  FROM chats c
  JOIN chat_members me
    ON me.chat_id = c.id AND me.user_id = auth.uid()
  LEFT JOIN chat_members other
    ON other.chat_id = c.id
    AND other.user_id != auth.uid()
    AND c.type = 'direct'
  LEFT JOIN profiles p
    ON p.id = other.user_id
  LEFT JOIN LATERAL (
    SELECT m.message_content, m.created_at
    FROM messages m
    WHERE m.chat_id = c.id
      AND m.deleted_at IS NULL
    ORDER BY m.created_at DESC
    LIMIT 1
  ) last_msg ON true
  WHERE c.space_id = p_space_id
    AND c.deleted_at IS NULL
  ORDER BY last_msg.created_at DESC NULLS LAST;
$$;