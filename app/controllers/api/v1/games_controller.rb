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
      end
    end
  end
end
