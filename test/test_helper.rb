$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')

require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!
require 'pry'
require 'classifier-reborn'
include ClassifierReborn
