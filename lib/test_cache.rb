require 'redis'
require './cache_client'
class A
  include CacheClient
  redis = Redis.new(:host => '127.0.0.1', :port => 6379)
  cache_client :se, redis, :default => [1]

  attr_accessor :id
  def initialize(id)
    @id = id
  end
end
