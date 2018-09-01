class Api::V1::Games::ShotsController < ApiController
  def create
    game = Game.find(params[:game_id])
    api_key = request.headers['X-API-Key']
    target = params[:shot][:target]
    if User.find_by_api_key(api_key)
      # turn_processor = TurnProcessor.new(game, target)


          if !game.player_1_board.space_names.include?(target)
            render status: 400, json: game, message: "Invalid coordinates."
          elsif !game.winner.nil?
            render status: 400, json: game, message: "Invalid move. Game over."
          else

                check = PlayerTurnCheck.new(game, api_key, target)
                render json: check.game_return, status: check.status_return, message: check.message_return
                
          end
        else
          render json: {message: "Unauthorized"}, status: 401
        end
  end
end
