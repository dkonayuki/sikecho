json.array!(@users) do |user|
  json.extract! user, :id, :name, :password_digest, :email, :nickname, :university, :faculty, :course, :nickname, :first_name, :last_name, :avatar, :dob, :status
  json.url user_url(user, format: :json)
end
