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
    1.upto(10**6) do |i| @board["user#{i}"] = 1 end
  end

  it "Results" do
    t = Time.now
    get "/"
    puts "Top10: %s" % [Time.now - t]

    t = Time.now
    get "/user888888"
    puts "Get rank: %s" % [Time.now - t]

    t = Time.now
    get "/user888888/2000"
    puts "Update: %s" % [Time.now - t]
  end
end
