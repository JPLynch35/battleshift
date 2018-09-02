class Api::V1::Games::ShipsController < ApiController
  def create
    game_id = params[:game_id]
    api_key = request.headers['X-API-Key']
    game_finder = GameFinder.new(game_id, api_key)
    @game = game_finder.retrieve_game
    return unauthorized if @game == nil
    return unauthorized if board == nil
    place_ship
    message
  end

  private
    def ship_params
      params.require('ship').permit(:ship_size, :start_space, :end_space)
    end

    def board
      return @game.player_1_board if request.headers['X-API-KEY'] == @game.player_1_key
      return @game.player_2_board if request.headers['X-API-KEY'] == @game.player_2_key
      nil
    end

    def unauthorized
      render json: {message: "Unauthorized"}, status: 401
    end

    def place_ship
      ShipPlacer.new(
        board: board,
        ship: Ship.new(ship_params[:ship_size]),
        start_space: ship_params[:start_space],
        end_space: ship_params[:end_space]
      ).run
      return @game.update_attribute(:player_1_board, board) if request.headers['X-API-KEY'] == @game.player_1_key
      @game.update_attribute(:player_2_board, board)
    end

    def message
      msg1 = "Successfully placed ship with a size of #{ship_params[:ship_size]}. You have 1 ship(s) to place with a size of 2."
      msg2 = "Successfully placed ship with a size of #{ship_params[:ship_size]}. You have 0 ship(s) to place."
      return (render json: @game, message: msg1) if ship_params[:ship_size] == 3
      render json: @game, message: msg2
    end
end
