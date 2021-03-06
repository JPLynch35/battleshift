class Api::V1::GamesController < ActionController::API
  def show
    game_id = params[:id]
    api_key = request.headers['X-API-Key']
    game_finder = GameFinder.new(game_id, api_key)
    game = game_finder.retrieve_game
    if game
      render json: game
    else
      render status: 400
    end
  end

  def create
    if User.find_by_api_key(request.headers['X-API-Key'])
      game_attributes = {
                      player_1_key: request.headers['X-API-Key'],
                      player_2_key: User.find_by_email(params[:opponent_email]).api_key,
                      player_1_board: Board.new(4),
                      player_2_board: Board.new(4),
                      player_1_turns: 0,
                      player_2_turns: 0,
                      current_turn: "challenger"
                    }
      game = Game.create(game_attributes)
      render json: game
    else
      render status: 401, json: {message: "Unauthorized"}
    end
  end
end
