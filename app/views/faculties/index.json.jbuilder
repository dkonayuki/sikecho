json.array!(@faculties) do |faculty|
  json.extract! faculty, :id, :name, :website, :university_id
  json.url faculty_url(faculty, format: :json)
end
