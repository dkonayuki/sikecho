json.array!(@courses) do |course|
  json.extract! course, :id, :name, :faculty_id
  json.url course_url(course, format: :json)
end
