module Api
  module V1
    class GamesController < ActionController::API
      def show
        game = Game.find_by_id(params[:id])
        if game
          render json: game
        else
          render status: 400
        end
      end

      def create
        game_attributes = {
                        player_1: User.find_by_api_key(request.headers['X-API-Key']),
                        player_2: User.find_by_email(params[:opponenet_email]),
                        player_1_board: Board.new(4),
                        player_2_board: Board.new(4),
                        player_1_turns: 0,
                        player_2_turns: 0,
                        current_turn: "challenger"
                      }

        binding.pry
        game  = Game.create()
      end
    end
  end
end
