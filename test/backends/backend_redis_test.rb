# frozen_string_literal: true

require File.dirname(__FILE__) + '/../test_helper'
require_relative './backend_common_tests'

class BackendRedisTest < Minitest::Test
  include BackendCommonTests

  def setup
    @backend = ClassifierReborn::BayesRedisBackend.new
    @backend.instance_variable_get(:@redis).config(:set, 'save', '')
  rescue Redis::CannotConnectError => e
    skip(e)
  end

  def teardown
    @backend.reset if defined? @backend
  end
end
