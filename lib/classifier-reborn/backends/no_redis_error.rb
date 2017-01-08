class NoRedisError < LoadError
  def initialize
    msg =
      %q{The Redis Backend can only be used if Redis is installed.
        This error is raised from 'lib/classifier-reborn/backends/bayes_redis_backend.rb'.
        If you have encountered this error and would like to use the Redis Backend,
        please run 'gem install redis' or include 'gem "redis"' in
        your gemfile. For more info see https://github.com/jekyll/classifier-reborn#usage.
      }
    super(msg)
  end
end
