class Api::V1::Games::ShipsController < ApiController
  def create
    game = Game.find(params[:game_id])
    board = nil
    if request.headers['X-API-KEY'] == game.player_1_key
      board = game.player_1_board
    else request.headers['X-API-KEY'] == game.player_2_key
      board = game.player_2_board
    end
    return if board == nil
    ShipPlacer.new(
      board: board,
      ship: Ship.new(ship_params[:ship_size]),
      start_space: ship_params[:start_space],
      end_space: ship_params[:end_space]
    ).run
    if request.headers['X-API-KEY'] == game.player_1_key
      game.update_attribute(:player_1_board, board)
    else
      game.update_attribute(:player_2_board, board)
    end
    if ship_params[:ship_size] == 3
      render json: game, message: "Successfully placed ship with a size of #{ship_params[:ship_size]}. You have 1 ship(s) to place with a size of 2."
    else
      render json: game, message: "Successfully placed ship with a size of #{ship_params[:ship_size]}. You have 0 ship(s) to place."
    end
  end

  private
    def ship_params
      params.require('ship').permit(:ship_size, :start_space, :end_space)
    end
end
