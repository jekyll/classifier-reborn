# frozen_string_literal: true

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')

require 'minitest/autorun'
require 'minitest/benchmark'
require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
require 'pry'
require 'classifier-reborn'
require 'classifier-reborn/backends/bayes_redis_backend'
include ClassifierReborn
