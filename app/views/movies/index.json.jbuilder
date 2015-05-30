json.array!(@movies) do |movie|
  json.extract! movie, :name, :movie_url, :image_url
  json.url movie_url(movie, format: :json)
end