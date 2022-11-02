json.block_user_detail do
  json.id @block_user_detail.id
  json.blocked_user_id @block_user_detail.blocked_user_id
  json.blocked_by @block_user_detail.user_id
end