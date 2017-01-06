begin
  require 'redis'
rescue LoadError
  puts 'The redis gem is required to use the redis backend.'
end

module ClassifierReborn
  class BayesRedisBackend
    def initialize(options = {})
      @redis = Redis.new(options)
      @redis.set(:total_words, 0)
      @redis.set(:total_trainings, 0)
    end

    def total_words
      @redis.get(:total_words).to_i
    end

    def update_total_words(diff)
      @redis.incrby(:total_words, diff)
    end

    def total_trainings
      @redis.get(:total_trainings).to_i
    end

    def update_total_trainings(diff)
      @redis.incrby(:total_trainings, diff)
    end

    def category_training_count(category)
      @redis.hget(:category_training_count, category).to_i
    end

    def update_category_training_count(category, diff)
      @redis.hincrby(:category_training_count, category, diff)
    end

    def category_has_trainings?(category)
      category_training_count(category) > 0
    end

    def category_word_count(category)
      @redis.hget(:category_word_count, category).to_i
    end

    def update_category_word_count(category, diff)
      @redis.hincrby(:category_word_count, category, diff)
    end

    def add_category(category)
      @redis.sadd(:category_keys, category)
    end

    def category_keys
      @redis.smembers(:category_keys).map(&:intern)
    end

    def category_word_frequency(category, word)
      @redis.hget(category, word).to_i
    end

    def update_category_word_frequency(category, word, diff)
      @redis.hincrby(category, word, diff)
    end

    def delete_category_word(category, word)
      @redis.hdel(category, word)
    end

    def word_in_category?(category, word)
      @redis.hexists(category, word)
    end
  end
end
