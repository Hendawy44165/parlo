create or replace function create_conversation(target_user_email text)
returns uuid
language plpgsql
security definer
as $$
declare
  current_user_id uuid := auth.uid();
  target_user_id uuid;
  conversation_id_result uuid;
begin
  -- 1. Get the target user's ID from their email
  select id from public.users
  into target_user_id
  where email = target_user_email;

  if target_user_id is null then
    raise exception 'User with email % not found', target_user_email;
  end if;

  if current_user_id = target_user_id then
    raise exception 'Cannot create a conversation with yourself.';
  end if;

  -- 2. Check if a conversation between these two users already exists
  select cp1.conversation_id into conversation_id_result
  from public.conversation_participants as cp1
  join public.conversation_participants as cp2 on cp1.conversation_id = cp2.conversation_id
  where cp1.user_id = current_user_id
    and cp2.user_id = target_user_id
  limit 1;

  -- 3. If a conversation is found, return its ID
  if conversation_id_result is not null then
    return conversation_id_result;
  end if;

  -- 4. If no conversation is found, create a new one
  insert into public.conversations (id) values (gen_random_uuid())
  returning id into conversation_id_result;

  -- 5. Create the two conversation participant records
  insert into public.conversation_participants (user_id, conversation_id)
  values
    (current_user_id, conversation_id_result),
    (target_user_id, conversation_id_result);

  -- 6. Return the newly created conversation ID
  return conversation_id_result;
end;
$$;
