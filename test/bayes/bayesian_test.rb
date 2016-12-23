# encoding: utf-8

require File.dirname(__FILE__) + '/../test_helper'
require_relative './bayesian_common_tests'

class BayesianTest < Test::Unit::TestCase
  include BayesianCommonTests

  def setup
    @classifier = ClassifierReborn::Bayes.new 'Interesting', 'Uninteresting'
  end
end
