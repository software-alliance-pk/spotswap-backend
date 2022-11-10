json.user do
  json.id user.id
  json.name user.name
  json.email user.email
  json.contact user.contact
  json.country_code user.country_code
  json.profile_complete user.profile_complete
  json.profile_type user.profile_type
  json.is_info_complete user.is_info_complete
  json.otp user.otp
  json.referral_code user.referral_code
  json.image user.image.attached? ? user.image.url : ""
  json.token token if token.present?
end