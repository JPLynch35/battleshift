require 'rails_helper'

describe 'POST /api/v1/games/:id/ship' do
  it 'user can place first ship' do
    user1 = User.create(name: 'Angela', email: 'Bob@Bob.Bob', password: 'Bob', status: 1, api_key: SecureRandom.hex(32))
    user2 = User.create(name: 'JP', email: 'JP@Bob.Bob', password: 'JP', status: 1, api_key: SecureRandom.hex(32))
    game_attributes = {
      player_1_key: user1.api_key,
      player_2_key: user2.api_key,
      player_1_board: Board.new(4),
      player_2_board: Board.new(4),
      player_1_turns: 0,
      player_2_turns: 0,
      current_turn: "challenger"
    }
    game = Game.create(game_attributes)
    json_payload = {
      ship_size: 3,
      start_space: "A1",
      end_space: "A3"
    }.to_json
    headers = {"X-API-Key" => user1.api_key, "CONTENT_TYPE" => "application/json" }

    post "/api/v1/games/#{game.id}/ship", params: json_payload, headers: headers
    
    expect(response).to be(success)
    expect(response.body[:message]).to eq("Successfully placed ship with a size of 3. You have 1 ship(s) to place with a size of 2.")
    require 'pry'; binding.pry
    expect(game_attributes[:player_1_board].board.first.first['A1'].contents).to be(Ship)
  end
end
