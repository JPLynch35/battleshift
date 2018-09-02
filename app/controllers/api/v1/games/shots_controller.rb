class Api::V1::Games::ShotsController < ApiController
  def create
    game = Game.find(params[:game_id])
    api_key = request.headers['X-API-Key']
    target = params[:shot][:target]
    if User.find_by_api_key(api_key)
      # turn_processor = TurnProcessor.new(game, target)


          # if !game.player_1_board.space_names.include?(target)
          #   render status: 400, json: game, message: "Invalid coordinates."
          # else

                check = PlayerMoveCheck.new(game, api_key, target)
                render json: check.game_return, status: check.status_return, message: check.message_return
                # render_correct

          # end


        else
          render json: {message: "Unauthorized"}, status: 401
        end
  end
  # private
  # attr_reader :check

  # def render_correct
  #   game = check.game_return
  #   message = check.message_return
  #   status = check.status_return
  #   if message == 'Invalid coordinates.'
  #     render json: game, status: 400, message: message
  #   else
  #     render json: game, status: status, message: message
  #   end
  # end
end
