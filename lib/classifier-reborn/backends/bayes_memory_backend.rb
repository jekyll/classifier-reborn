# Author: Sawood Alam <@ibnesayeed>

module ClassifierReborn
  class BayesMemoryBackend
    def initialize
      @total_words     = 0
      @total_trainings = 0
      @category_counts = Hash.new { |h, k| h[k] = {training: 0, word: 0} }
      @categories      = {}
    end

    def total_words
      @total_words
    end

    def update_total_words(diff)
      @total_words += diff
    end

    def total_trainings
      @total_trainings
    end

    def update_total_trainings(diff)
      @total_trainings += diff
    end

    def category_training_count(category)
      @category_counts[category][:training]
    end

    def update_category_training_count(category, diff)
      @category_counts[category][:training] += diff
    end

    def category_has_trainings?(category)
      @category_counts.key?(category) && @category_counts[category][:training] > 0
    end

    def category_word_count(category)
      @category_counts[category][:word]
    end

    def update_category_word_count(category, diff)
      @category_counts[category][:word] += diff
    end

    def add_category(category)
      @categories[category] ||= Hash.new(0)
    end

    def category_keys
      @categories.keys
    end

    def category_word_frequency(category, word)
      @categories[category][word]
    end

    def update_category_word_frequency(category, word, diff)
      @categories[category][word] += diff
    end

    def delete_category_word(category, word)
      @categories[category].delete(word)
    end

    def word_in_category?(category, word)
      @categories[category].key?(word)
    end
  end
end
