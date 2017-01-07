$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')

require 'minitest/autorun'
require "minitest/benchmark"
require 'minitest/reporters'
Minitest::Reporters.use! unless ENV['NOPROGRESS']
require 'pry'
require 'classifier-reborn'
include ClassifierReborn
