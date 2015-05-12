json.array!(@quotes) do |quote|
  json.extract! quote, :id, :content, :episode_id, :time
  json.url quote_url(quote, format: :json)
end
