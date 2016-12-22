module ClassifierReborn
  class BayesRedisBackend
    def initialize(redis_con_str)
      # TODO: Initialize Redis connection and necessary data structures
    end

    def total_words
      # TODO: Yet to implement
    end

    def update_total_words(diff)
      # TODO: Yet to implement
    end

    def total_trainings
      # TODO: Yet to implement
    end

    def update_total_trainings(diff)
      # TODO: Yet to implement
    end

    def category_training_count(category)
      # TODO: Yet to implement
    end

    def update_category_training_count(category, diff)
      # TODO: Yet to implement
    end

    def category_has_trainings?(category)
      # TODO: Yet to implement
    end

    def category_word_count(category)
      # TODO: Yet to implement
    end

    def update_category_word_count(category, diff)
      # TODO: Yet to implement
    end

    def add_category(category)
      # TODO: Yet to implement
    end

    def category_keys
      # TODO: Yet to implement
    end

    def category_word_frequency(category, word)
      # TODO: Yet to implement
    end

    def update_category_word_frequency(category, word, diff)
      # TODO: Yet to implement
    end

    def delete_category_word(category, word)
      # TODO: Yet to implement
    end

    def word_in_category?(category, word)
      # TODO: Yet to implement
    end
  end
end
