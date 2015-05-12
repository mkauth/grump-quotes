json.array!(@rejecteds) do |rejected|
  json.extract! rejected, :id, :name
  json.url rejected_url(rejected, format: :json)
end
