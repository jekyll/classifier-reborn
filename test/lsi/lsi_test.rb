# frozen_string_literal: true

require File.dirname(__FILE__) + '/../test_helper'

class LSITest < Minitest::Test
  def setup
    # we repeat principle words to help weight them.
    # This test is rather delicate, since this system is mostly noise.
    @str1 = 'This text deals with dogs. Dogs.'
    @str2 = 'This text involves dogs too. Dogs! '
    @str3 = 'This text revolves around cats. Cats.'
    @str4 = 'This text also involves cats. Cats!'
    @str5 = 'This text involves birds. Birds.'
  end

  def test_basic_indexing
    lsi = ClassifierReborn::LSI.new
    [@str1, @str2, @str3, @str4, @str5].each { |x| lsi << x }
    assert !lsi.needs_rebuild?

    # note that the closest match to str1 is str2, even though it is not
    # the closest text match.
    assert_equal [@str2, @str5, @str3], lsi.find_related(@str1, 3)
  end

  def test_not_auto_rebuild
    lsi = ClassifierReborn::LSI.new auto_rebuild: false
    lsi.add_item @str1, 'Dog'
    lsi.add_item @str2, 'Dog'
    assert lsi.needs_rebuild?
    lsi.build_index
    assert !lsi.needs_rebuild?
  end

  def test_zero_vector_normalization
    lsi = ClassifierReborn::LSI.new auto_rebuild: false
    lsi.add_item @str1[0...8], 'Dog'
    lsi.add_item @str2, 'Dog'
    lsi.add_item @str3, 'Cat'
    lsi.build_index(0.75)
  end

  def test_basic_categorizing
    lsi = ClassifierReborn::LSI.new
    lsi.add_item @str2, 'Dog'
    lsi.add_item @str3, 'Cat'
    lsi.add_item @str4, 'Cat'
    lsi.add_item @str5, 'Bird'

    assert_equal 'Dog', lsi.classify(@str1)
    assert_equal 'Cat', lsi.classify(@str3)
    assert_equal 'Bird', lsi.classify(@str5)
  end

  def test_basic_categorizing_with_score
    lsi = ClassifierReborn::LSI.new
    lsi.add_item @str2, 'Dog'
    lsi.add_item @str3, 'Cat'
    lsi.add_item @str4, 'Cat'
    lsi.add_item @str5, 'Bird'

    assert_in_delta 2.49, lsi.classify_with_score(@str1)[1], 0.1
    assert_in_delta 1.41, lsi.classify_with_score(@str3)[1], 0.1
    assert_in_delta 1.99, lsi.classify_with_score(@str5)[1], 0.1
  end

  def test_scored_categories
    lsi = ClassifierReborn::LSI.new
    lsi.add_item @str1, 'Dog'
    lsi.add_item @str2, 'Dog'
    lsi.add_item @str3, 'Cat'
    lsi.add_item @str4, 'Cat'
    lsi.add_item @str5, 'Bird'

    scored_categories = lsi.scored_categories('dog bird cat')
    assert_equal 2, scored_categories.size
    assert_equal %w[Bird Dog], scored_categories.map(&:first)
  end

  def test_external_classifying
    lsi = ClassifierReborn::LSI.new
    bayes = ClassifierReborn::Bayes.new 'Dog', 'Cat', 'Bird'
    lsi.add_item @str1, 'Dog'
    bayes.train_dog @str1
    lsi.add_item @str2, 'Dog'
    bayes.train_dog @str2
    lsi.add_item @str3, 'Cat'
    bayes.train_cat @str3
    lsi.add_item @str4, 'Cat'
    bayes.train_cat @str4
    lsi.add_item @str5, 'Bird'
    bayes.train_bird @str5

    # We're talking about dogs. Even though the text matches the corpus on
    # cats better.  Dogs have more semantic weight than cats. So bayes
    # will fail here, but the LSI recognizes content.
    tricky_case = 'This text revolves around dogs.'
    assert_equal 'Dog', lsi.classify(tricky_case)
    refute_equal 'Dog', bayes.classify(tricky_case)
  end

  def test_recategorize_interface
    lsi = ClassifierReborn::LSI.new
    lsi.add_item @str1, 'Dog'
    lsi.add_item @str2, 'Dog'
    lsi.add_item @str3, 'Cat'
    lsi.add_item @str4, 'Cat'
    lsi.add_item @str5, 'Bird'

    tricky_case = 'This text revolves around dogs.'
    assert_equal 'Dog', lsi.classify(tricky_case)

    # Recategorize as needed.
    lsi.categories_for(@str1).clear.push 'Cow'
    lsi.categories_for(@str2).clear.push 'Cow'

    assert !lsi.needs_rebuild?
    assert_equal 'Cow', lsi.classify(tricky_case)
  end

  def test_search
    lsi = ClassifierReborn::LSI.new
    [@str1, @str2, @str3, @str4, @str5].each { |x| lsi << x }

    # Searching by content and text, note that @str2 comes up first, because
    # both "dog" and "involve" are present. But, the next match is @str1 instead
    # of @str4, because "dog" carries more weight than involves.
    assert_equal([@str2, @str1, @str4, @str5, @str3],
                 lsi.search('dog involves', 100))

    # Keyword search shows how the space is mapped out in relation to
    # dog when magnitude is remove. Note the relations. We move from dog
    # through involve and then finally to other words.
    assert_equal([@str1, @str2, @str4, @str5, @str3],
                 lsi.search('dog', 5))
  end

  def test_serialize_safe
    lsi = ClassifierReborn::LSI.new
    [@str1, @str2, @str3, @str4, @str5].each { |x| lsi << x }

    lsi_md = Marshal.dump lsi
    lsi_m = Marshal.load lsi_md

    assert_equal lsi_m.search('cat', 3), lsi.search('cat', 3)
    assert_equal lsi_m.find_related(@str1, 3), lsi.find_related(@str1, 3)
  end

  def test_uncached_content_node_option
    lsi = ClassifierReborn::LSI.new
    [@str1, @str2, @str3, @str4, @str5].each { |x| lsi << x }
    lsi.instance_variable_get(:@items).values.each do |node|
      assert node.instance_of?(ContentNode)
    end
  end

  def test_cached_content_node_option
    lsi = ClassifierReborn::LSI.new(cache_node_vectors: true)
    [@str1, @str2, @str3, @str4, @str5].each { |x| lsi << x }
    lsi.instance_variable_get(:@items).values.each do |node|
      assert node.instance_of?(CachedContentNode)
    end
  end

  def test_clears_cached_content_node_cache
    skip "transposed_search_vector is only used by GSL implementation" unless $GSL

    lsi = ClassifierReborn::LSI.new(cache_node_vectors: true)
    lsi.add_item @str1, 'Dog'
    lsi.add_item @str2, 'Dog'
    lsi.add_item @str3, 'Cat'
    lsi.add_item @str4, 'Cat'
    lsi.add_item @str5, 'Bird'

    assert_equal 'Dog', lsi.classify('something about dogs, but not an exact dog string')

    first_content_node = lsi.instance_variable_get(:@items).values.first
    refute_nil first_content_node.instance_variable_get(:@transposed_search_vector)
    lsi.clear_cache!
    assert_nil first_content_node.instance_variable_get(:@transposed_search_vector)
  end

  def test_keyword_search
    lsi = ClassifierReborn::LSI.new
    lsi.add_item @str1, 'Dog'
    lsi.add_item @str2, 'Dog'
    lsi.add_item @str3, 'Cat'
    lsi.add_item @str4, 'Cat'
    lsi.add_item @str5, 'Bird'

    assert_equal %i[dog text deal], lsi.highest_ranked_stems(@str1)
  end

  def test_invalid_searching_when_using_gsl
    skip "Only GSL currently raises invalid search error" unless $GSL

    lsi = ClassifierReborn::LSI.new
    lsi.add_item @str1, 'Dog'
    lsi.add_item @str2, 'Dog'
    lsi.add_item @str3, 'Cat'
    lsi.add_item @str4, 'Cat'
    lsi.add_item @str5, 'Bird'
    assert_output(/There are no documents that are similar to penguin/) { lsi.search('penguin') }
  end

  def test_warn_when_adding_bad_document
    lsi = ClassifierReborn::LSI.new
    assert_output(/Input: 'i can' is entirely stopwords or words with 2 or fewer characters. Classifier-Reborn cannot handle this document properly./) { lsi.add_item('i can') }
  end

  def test_summary
    assert_equal 'This text involves dogs too [...] This text also involves cats', Summarizer.summary([@str1, @str2, @str3, @str4, @str5].join, 2)
  end

  def test_reset
    lsi = ClassifierReborn::LSI.new
    assert lsi.items.empty?
    lsi.add_item @str1, 'Dog'
    refute lsi.items.empty?
    lsi.reset
    assert lsi.items.empty?
    lsi.add_item @str3, 'Cat'
    refute lsi.items.empty?
  end
end
