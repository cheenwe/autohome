# Custom Redis configuration
config_file = Rails.root.join('config', 'redis.yml')

resque_url = if File.exists?(config_file)
		YAML.load_file(config_file)[Rails.env]
	else
		"redis://localhost:6379"
	end

Sidekiq.configure_server do |config|
	config.redis = {
		url: resque_url,
		namespace: 'resque:wei'
	}
end

Sidekiq.configure_client do |config|
	config.redis = {
		url: resque_url,
		namespace: 'resque:wei'
	}
end



# redis_server = '127.0.0.1' # redis服务器
# redis_port = 6379 # redis端口
# redis_db_num = 0 # redis 数据库序号
# redis_namespace = 'resque_wei' #命名空间，自定义的

# Sidekiq.configure_server do |config|
#   p redis_server  # 这个可以去掉
#   config.redis = { url: "redis://#{redis_server}:#{redis_port}/#{redis_db_num}", namespace: redis_namespace }


# Sidekiq.configure_client do |config|
#   config.redis = { url: "redis://#{redis_server}:#{redis_port}/#{redis_db_num}", namespace: redis_namespace }
# end

