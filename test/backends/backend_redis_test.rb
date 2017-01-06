# encoding: utf-8

require File.dirname(__FILE__) + '/../test_helper'
require_relative './backend_common_tests'

class BackendRedisTest < Minitest::Test
  include BackendCommonTests

  def setup
    begin
      @backend = ClassifierReborn::BayesRedisBackend.new
      @backend.instance_variable_get(:@redis).config(:set, "save", "")
    rescue Redis::CannotConnectError => e
      skip(e)
    end
  end

  def teardown
    @backend.instance_variable_get(:@redis).flushdb
  end
end
