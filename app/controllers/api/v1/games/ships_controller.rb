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
    render json: game, message: "Successfully placed ship with a size of 3. You have 1 ship(s) to place with a size of 2."
  end
end
