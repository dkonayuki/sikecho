json.array!(@educations) do |education|
  json.extract! education, :id, :uni_year_id, :semester_id, :year, :university_id, :faculty_id, :course_id, :user_id
  json.url education_url(education, format: :json)
end
