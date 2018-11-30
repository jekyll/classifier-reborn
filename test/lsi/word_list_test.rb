require_relative '../test_helper'

class WordListTest < Minitest::Test
  def test_size_does_not_count_words_twice
    list = ClassifierReborn::WordList.new
    assert list.size.zero?

    list.add_word('hello')
    assert list.size == 1

    list.add_word('hello')
    assert list.size == 1

    list.add_word('world')
    assert list.size == 2
  end

  def test_brackets_return_correct_position_based_on_add_order
    list = ClassifierReborn::WordList.new
    list.add_word('hello')
    list.add_word('world')
    assert list['hello'].zero?
    assert list['world'] == 1
  end

  def test_word_for_index_returns_correct_word_based_on_add_order
    list = ClassifierReborn::WordList.new
    list.add_word('hello')
    list.add_word('world')
    assert list.word_for_index(0) == 'hello'
    assert list.word_for_index(1) == 'world'
  end
end
