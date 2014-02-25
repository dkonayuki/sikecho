json.array!(@documents) do |document|
  json.extract! document, :id, :note_id
  json.url document_url(document, format: :json)
end
