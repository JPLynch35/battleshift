require 'rails_helper'

describe 'GET /api/v1/games/1' do
  context 'with an existing game' do
    it 'returns a game with boards' do
      user1 = User.create(name: 'Angela', email: 'Bob@Bob.Bob', password: 'Bob', status: 1, api_key: SecureRandom.hex(32))
      user2 = User.create(name: 'JP', email: 'JP@Bob.Bob', password: 'JP', status: 1, api_key: SecureRandom.hex(32))
      player_1_board = Board.new(4)
      player_2_board = Board.new(4)

      game_attributes = {
        player_1_key: user1.api_key,
        player_2_key: user2.api_key,
        player_1_board: Board.new(4),
        player_2_board: Board.new(4),
        player_1_turns: 0,
        player_2_turns: 0,
        current_turn: "challenger"
      }

      game = Game.create!(game_attributes)

      headers = {"X-API-Key" => user1.api_key, "CONTENT_TYPE" => "application/json" }

      get "/api/v1/games/#{game.id}", headers: headers

      actual = JSON.parse(response.body, symbolize_names: true)
      expected = Game.last

      expect(response).to be_success
      expect(actual[:id]).to eq(expected.id)
      expect(actual[:current_turn]).to eq(expected.current_turn)
      expect(actual[:player_1_board][:rows].count).to eq(4)
      expect(actual[:player_2_board][:rows].count).to eq(4)
      expect(actual[:player_1_board][:rows][0][:name]).to eq("row_a")
      expect(actual[:player_1_board][:rows][3][:data][0][:coordinates]).to eq("D1")
      expect(actual[:player_1_board][:rows][3][:data][0][:coordinates]).to eq("D1")
      expect(actual[:player_1_board][:rows][3][:data][0][:status]).to eq("Not Attacked")
    end
  end

  describe 'with no game' do
    it 'returns a 400' do
      get "/api/v1/games/1"

      expect(response.status).to eq(400)
    end
  end

  it 'will not create game without valid credentials in the post request' do

    post "/api/v1/games"

    expect(response.status).to eq(401)
  end
end
