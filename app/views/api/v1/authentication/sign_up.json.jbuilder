json.user do
  json.id @user.id
  json.name @user.name
  json.email @user.email
  json.contact @user.contact
  json.password @user.password_digest
end