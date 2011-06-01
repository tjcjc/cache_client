require 'rspec'
require 'memcache'
require 'redis'
require './cache_client'
class Test
  include CacheClient
  attr_accessor :id
  def initialize(id)
    @id = id
  end

  cache_client :red_val, Redis.new(:host => "127.0.0.1", :port => 6379)
  cache_client :mem_val, MemCache.new("127.0.0.1:11211")
end

describe CacheClient do
  before(:each) do
    @t = Test.new(1)
  end
  it "test redis" do
    @t.red_val.should == nil
    @t.red_val = "test redis"
    @t.red_val.should == "test redis"
    Test.get_red_val([1]).first.should == "test redis"
    Test.del_red_val([1]).first.should == Test.servers_field_key(1, "red_val")
    @t.red_val.should == nil
  end

  it "test memcahce" do
    pre_key = Test.servers_field_key(1, "mem_val")
    @t.mem_val.should == nil
    @t.mem_val = "test memcached"
    @t.mem_val.should == "test memcached"
    Test.get_mem_val([1]).should == {pre_key => "test memcached"}
    Test.del_mem_val([1]).should == [pre_key]
  end
end

