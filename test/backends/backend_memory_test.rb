# encoding: utf-8

require File.dirname(__FILE__) + '/../test_helper'
require_relative './backend_common_tests'

class BackendMemoryTest < Minitest::Test
  include BackendCommonTests

  def setup
    @backend = ClassifierReborn::BayesMemoryBackend.new
  end
end
