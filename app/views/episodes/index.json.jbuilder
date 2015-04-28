json.array!(@episodes) do |episode|
  json.extract! episode, :id, :video_id, :game, :show, :title, :part, :duration, :thumbnail_url
  json.url episode_url(episode, format: :json)
end
