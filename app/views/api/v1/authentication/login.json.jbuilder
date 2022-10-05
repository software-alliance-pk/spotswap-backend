json.user do
  json.id @user.id
  json.name @user.name
  json.email @user.email
  json.token @token
  json.token_expiry @exp
end