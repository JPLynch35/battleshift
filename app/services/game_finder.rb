class GameFinder
  def initialize(id, api_key)
    @id = id
    @api_key = api_key
  end

  def retrieve_game
    Game.where(player_1_key: api_key).or(Game.where(player_2_key: api_key)).where(id: id).first
  end

  private
  attr_reader :id, :api_key
end