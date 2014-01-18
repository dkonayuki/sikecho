json.array!(@subjects) do |subject|
  json.extract! subject, :id, :name, :description, :subject_code, :credit, :term_id, :course_id, :teacher_id
  json.url subject_url(subject, format: :json)
end
