class Api::V1::Games::ShotsController < ApiController
  def create
    game = Game.find(params[:game_id])

    turn_processor = TurnProcessor.new(game, params[:shot][:target])
    if !game.player_1_board.space_names.include?(params[:shot][:target])
      render status: 400, json: game, message: "Invalid coordinates."
    else
      if game.current_turn == 'challenger' && request.headers['X-API-KEY'] == game.player_1_key
        turn_processor.run_player_1!
        render json: game, message: turn_processor.message
      elsif game.current_turn == 'opponent' && request.headers['X-API-KEY'] == game.player_2_key
        turn_processor.run_player_2!
        render json: game, message: turn_processor.message
      else
        render status: 400, json: game, message: "Invalid move. It's your opponent's turn"
      end
    end
  end
end
