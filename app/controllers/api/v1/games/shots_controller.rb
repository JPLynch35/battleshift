class Api::V1::Games::ShotsController < ApiController
  def create
    game = Game.find(params[:game_id])
    api_key = request.headers['X-API-Key']
    target = params[:shot][:target]
    
    check = PlayerMoveCheck.new(game, api_key, target)
    render json: check.game_return, status: check.status_return, message: check.message_return
  end
end
