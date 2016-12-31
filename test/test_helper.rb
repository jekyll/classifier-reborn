$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')

require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!
require 'classifier-reborn'
include ClassifierReborn
