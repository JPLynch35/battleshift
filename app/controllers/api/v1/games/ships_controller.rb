class Api::V1::Games::ShipsController < ApiController
  def create
    game = Game.find(params[:game_id])
    body = JSON.parse(request.raw_post, symbolize_names: true)
    ShipPlacer.new(
      board: game.player_1_board,
      ship: Ship.new(body[:ship_size]),
      start_space: body[:start_space],
      end_space: body[:end_space]
    ).run
    game.update_attribute(:player_1_board, game.player_1_board)
    if body[:ship_size] == 3
      render json: game, message: "Successfully placed ship with a size of #{body[:ship_size]}. You have 1 ship(s) to place with a size of 2."
    else
      render json: game, message: "Successfully placed ship with a size of #{body[:ship_size]}. You have 0 ship(s) to place."
    end
  end
end
