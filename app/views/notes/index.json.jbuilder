json.array!(@notes) do |note|
  json.extract! note, :id, :title, :content, :image_path, :pdf_path, :user_id, :subject_id
  json.url note_url(note, format: :json)
end
