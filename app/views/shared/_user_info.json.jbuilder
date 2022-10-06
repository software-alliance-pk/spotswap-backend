json.user do
  json.id user.id
  json.name user.name
  json.email user.email
  json.contact user.contact
  json.profile_complete user.profile_complete
  json.profile_type user.profile_type
  json.otp user.otp
  json.token token if token.present?
end