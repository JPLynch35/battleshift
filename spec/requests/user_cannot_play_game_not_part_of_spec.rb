require 'rails_helper'

describe "POST /api/v1/games/:id/shots" do
  before :each do
    @user1 = User.create(name: 'Angela', email: 'Bob@Bob.Bob', password: 'Bob', status: 1, api_key: SecureRandom.hex(32))
    @user2 = User.create(name: 'JP', email: 'JP@Bob.Bob', password: 'JP', status: 1, api_key: SecureRandom.hex(32))
    game_attributes = {
      player_1_key: @user1.api_key,
      player_2_key: @user2.api_key,
      player_1_board: Board.new(4),
      player_2_board: Board.new(4),
      player_1_turns: 0,
      player_2_turns: 0,
      current_turn: "challenger"
    }
    @game = Game.create(game_attributes)
  end
  it 'a player cannot play a game they are not a part of' do
    allow(@game).to receive(:id).and_return(1)
    allow(@user2).to receive(:api_key).and_return("ChangedToBadKey")

    json_payload = {target: "A1"}.to_json
    headers = {"X-API-Key" => @user2.api_key, "CONTENT_TYPE" => "application/json" }
    post "/api/v1/games/#{@game.id}/shots", params: json_payload, headers: headers
    
    expect(response.status).to eq(401)
    expect(JSON.parse(response.body, symbolize_names: true)[:message]).to eq("Unauthorized")
  end
end
