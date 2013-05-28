require "test_helper.rb"
require "leaderboard"

class LeaderboardTest < MiniTest::Unit::TestCase

  def setup
    @board = Leaderboard.new("game_1")

    # Flush the redis database before each test run
    @redis = Redis.new
    @redis.flushall
  end

  def test_top10_on_empty_scoreboard
    assert_equal [], @board.top10
  end

  def test_my_rank_is_nil_when_scoreboard_is_empty
    assert_equal nil, @board.rank("user1")
  end

  def test_score_is_nil_when_user_does_not_exist
    assert_equal nil, @board["user1"]
  end

  def test_stores_the_score_persistently
    @board["user1"] = 10
    assert_equal 10, @board["user1"]
  end

  def test_top10_for_multiple_players_with_scores
    @board["user1"] = 10
    @board["user3"] = 20
    @board["user2"] = 30
    assert_equal [["user2", 30.0], ["user3", 20.0],  ["user1", 10.0]], @board.top10
  end

  def test_top10_shows_only_the_first_10_players
    1.upto(15) { |i| @board["user#{i}"] = i }
    assert_equal 10, @board.top10.length
  end

  def test_rank_when_user_is_not_in_top10
    1.upto(15) { |i| @board["user#{i}"] = 100-i}
    assert_equal 15, @board.rank("user15")
  end

  def test_when_score_change
    @board["user1"] = 10
    @board["user2"] = 20
    @board["user3"] = 30

    @board["user1"] = 40
    assert_equal 1, @board.rank("user1")
  end

end