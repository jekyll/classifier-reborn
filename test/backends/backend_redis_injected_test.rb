require File.dirname(__FILE__) + '/../test_helper'
require 'redis'
require_relative './backend_common_tests'

class BackendRedisInjectedTest < Minitest::Test
  include BackendCommonTests

  def setup
    redis = Redis.new
    @backend = ClassifierReborn::BayesRedisBackend.new(redis_conn: redis)
    redis.config(:set, 'save', '')
  rescue Redis::CannotConnectError => e
    skip(e)
  end

  def teardown
    @backend.reset if defined? @backend
  end
end
