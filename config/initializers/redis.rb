yml       = YAML.load_file(File.join(Rails.root, "config", "redis.yml"))  
config    = yml["#{ Rails.env }"]  
namespace = "#{ Rails.application.class.parent_name.downcase }_#{ Rails.env.downcase }".to_sym

redis_connection = Redis.new(config)
$plivo_redis     = Redis::Namespace.new(namespace, redis: redis_connection)