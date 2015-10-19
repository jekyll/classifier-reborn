# encoding: utf-8

require File.dirname(__FILE__) + '/../test_helper'
class BayesianTest < Test::Unit::TestCase
	def setup
		@classifier = ClassifierReborn::Bayes.new 'Interesting', 'Uninteresting'
	end

	def test_good_training
		assert_nothing_raised { @classifier.train_interesting "love" }
	end

	def test_training_with_utf8
		assert_nothing_raised { @classifier.train_interesting "Água" }
	end

	def test_bad_training
		assert_raise(StandardError) { @classifier.train_no_category "words" }
	end

	def test_bad_method
		assert_raise(NoMethodError) { @classifier.forget_everything_you_know "" }
	end

	def test_categories
		assert_equal ['Interesting', 'Uninteresting'].sort, @classifier.categories.sort
	end

	def test_categories_from_array
		another_classifier = ClassifierReborn::Bayes.new ['Interesting', 'Uninteresting']
		assert_equal another_classifier.categories.sort, @classifier.categories.sort
	end

	def test_add_category
		@classifier.add_category 'Test'
		assert_equal ['Test', 'Interesting', 'Uninteresting'].sort, @classifier.categories.sort
	end

	def test_dynamic_category_succeeds_with_auto_categorize
		classifier = ClassifierReborn::Bayes.new 'Interesting', 'Uninteresting', auto_categorize: true
		classifier.train('Ruby', 'I really sweet language')
		assert classifier.categories.include?('Ruby')
	end

	def test_language_changing
		classifier = ClassifierReborn::Bayes.new 'Interesting', 'Uninteresting', language: "pt"
		assert_equal "pt", classifier.language
	end

	def test_dynamic_category_fails_without_auto_categorize
		assert_raises(ClassifierReborn::Bayes::CategoryNotFoundError) do
		  @classifier.train('Ruby', 'I really sweet language')
		end
		refute @classifier.categories.include?('Ruby')
	end

	def test_classification
		@classifier.train_interesting "here are some good words. I hope you love them"
		@classifier.train_uninteresting "here are some bad words, I hate you"
		assert_equal 'Uninteresting', @classifier.classify("I hate bad words and you")
	end

	def test_classification_with_score
		@classifier.train_interesting "here are some good words. I hope you love them"
		@classifier.train_uninteresting "here are some bad words, I hate you"
		assert_in_delta -4.85, @classifier.classify_with_score("I hate bad words and you")[1], 0.1
	end

	def test_untrain
		@classifier.train_interesting "here are some good words. I hope you love them"
		@classifier.train_uninteresting "here are some bad words, I hate you"
		@classifier.add_category 'colors'
		@classifier.train_colors "red orange green blue seven"
		classification_of_bad_data = @classifier.classify "seven"
		@classifier.untrain_colors "seven"
		classification_after_untrain = @classifier.classify "seven"
		assert_not_equal classification_of_bad_data, classification_after_untrain
	end

end
