require 'redis'

class Leaderboard

  def initialize(name)
    @name = name
    @redis = Redis.new
  end

  def []=(user_id, score)
    @redis.zadd(@name, score, user_id)
  end

  def [](user)
    @redis.zscore(@name, user)
  end

  def rank(user)
    rank = @redis.zrevrank(@name, user)

    # rank is 0-based
    rank && rank + 1
  end

  def top10
    @redis.zrevrange(@name, 0, 9, {withscores: true})
  end

end
