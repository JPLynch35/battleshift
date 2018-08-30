class Api::V1::Games::ShipsController < ApiController
  def create
    game = Game.find(params[:game_id])
    body = JSON.parse(request.raw_post, symbolize_names: true)
    if request.headers['X-API-KEY'] == game.player_1_key
      board = game.player_1_board
    else
      board = game.player_2_board
    end
    ShipPlacer.new(
      board: board,
      ship: Ship.new(body[:ship_size]),
      start_space: body[:start_space],
      end_space: body[:end_space]
    ).run
    if request.headers['X-API-KEY'] == game.player_1_key
      game.update_attribute(:player_1_board, board)
    else
      game.update_attribute(:player_2_board, board)
    end
    if body[:ship_size] == 3
      render json: game, message: "Successfully placed ship with a size of #{body[:ship_size]}. You have 1 ship(s) to place with a size of 2."
    else
      render json: game, message: "Successfully placed ship with a size of #{body[:ship_size]}. You have 0 ship(s) to place."
    end
  end
end
