redis_url = ENV["REDIS_URL"]
if redis_url
  REDIS = Redis.new(url: redis_url)
else
  REDIS = Redis.new(host: "127.0.0.1", port: 6379)
end