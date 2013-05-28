require 'server'
require "test_helper"

class ServerTest < MiniTest::Spec
  include Rack::Test::Methods

  def app
    Sinatra::Application.new
  end

  def setup
    @redis = Redis.new
    @redis.flushall

    @board = Leaderboard.new("game")
    1.upto(15) do |i| @board["user#{i}"] = 100-i end
  end

  describe :index do
    it "should return 200 status message" do
      get "/"
      assert 200, last_response.status
    end

    it "should return the top10 user with score in json" do
      get "/"

      iterations = 0
      JSON.parse(last_response.body).each do |row|
        expected_username = "user#{iterations+1}"
        expected_score = 100-(iterations+1)

        assert_equal expected_username, row["user"]
        assert_equal expected_score, row["score"].to_i
        iterations += 1
      end
      assert_equal 10, iterations
    end
  end

  describe :show do
    before { @user = "user11"; @score = 89.0; @rank = 11 }

    it "should return 200 status message if user exists" do
      get "/#{@user}"
      assert 200, last_response.status
    end

    it "should return 404 status message if user does not exist" do
      get "/appletree"
      assert 404, last_response.status
    end

    it "should show the rank of a user" do
      get "/user11"
      response = JSON.parse(last_response.body)
      assert_equal @user, response["user"]
      assert_equal @rank, response["rank"]
      assert_equal @score, response["score"]
    end
  end

  describe :create do
    it "should return 200 status message" do
      post "/new_user/111"
      assert 404, last_response.status
    end

    it "should create a user with score" do
      post "/new_user/111"
      assert_equal 111, @board["new_user"]
    end
  end

  describe :update do
    it "update the score of a user" do
      assert_equal 99, @board["user1"]
      post "/user1/1000"
      assert_equal 1000, @board["user1"]
    end
  end

end