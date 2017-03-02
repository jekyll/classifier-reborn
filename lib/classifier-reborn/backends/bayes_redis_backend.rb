require_relative 'no_redis_error'
# require redis when we run #intialize. This way only people using this backend
# will need to install and load the backend without having to
# require 'classifier-reborn/backends/bayes_redis_backend'

module ClassifierReborn
  # This class provides Redis as the storage backend for the classifier data structures
  class BayesRedisBackend
    # The class can be created with the same arguments that the redis gem accepts
    # E.g.,
    #      b = ClassifierReborn::BayesRedisBackend.new
    #      b = ClassifierReborn::BayesRedisBackend.new host: "10.0.1.1", port: 6380, db: 2
    #      b = ClassifierReborn::BayesRedisBackend.new url: "redis://:secret@10.0.1.1:6380/2"
    #
    # Options available are:
    #   url:                lambda { ENV["REDIS_URL"] }
    #   scheme:             "redis"
    #   host:               "127.0.0.1"
    #   port:               6379
    #   path:               nil
    #   timeout:            5.0
    #   password:           nil
    #   db:                 0
    #   driver:             nil
    #   id:                 nil
    #   tcp_keepalive:      0
    #   reconnect_attempts: 1
    #   inherit_socket:     false
    def initialize(options = {})
      begin # because some people don't have redis installed
        require 'redis'
      rescue LoadError
        raise NoRedisError
      end

      @redis = Redis.new(options)
      @redis.setnx(:total_words, 0)
      @redis.setnx(:total_trainings, 0)
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

    def reset
      @redis.flushdb
      @redis.set(:total_words, 0)
      @redis.set(:total_trainings, 0)
    end
  end
end
