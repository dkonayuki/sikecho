json.array!(@teachers) do |teacher|
  json.extract! teacher, :id, :first_name, :first_name_kana, :last_name, :last_name_kana, :role, :university_id, :faculty_id
  json.url teacher_url(teacher, format: :json)
end
