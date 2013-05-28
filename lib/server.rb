require 'json'
require 'sinatra'

require_relative 'leaderboard'

before do
  content_type :json
  @board = Leaderboard.new("game")
end

# index
get "/" do
  @board.top10.map do |entry|
    {:user => entry[0], :score => entry[1]}
  end.to_json
end

# show
get "/:name" do
  rank = @board.rank(params[:name])
  score = @board[params[:name]]

  if rank && score
    {user: params[:name], rank: rank, score: score}.to_json
  else
    response.status = 404
  end
end

# create
# update
post "/:name/:score" do
  @board[params[:name]] = params[:score]
end