-- default now() fires only at insert, so updated_at would freeze forever
-- without this. It is what tells us a device is still alive.
create trigger set_device_tokens_updated_at
before update on public.device_tokens
for each row
execute function public.touch_updated_at();