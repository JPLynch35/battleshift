require 'rails_helper'

describe 'POST /api/v1/games/:id/ships' do
  it 'users can place ships' do
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

    post "/api/v1/games/#{game.id}/ships", params: json_payload, headers: headers

    expect(response.status).to be(200)
    expect(JSON.parse(response.body, symbolize_names: true)[:message]).to eq("Successfully placed ship with a size of 3. You have 1 ship(s) to place with a size of 2.")
    expect(Game.last.player_1_board.board.first.first['A1'].contents).to be_a(Ship)

    # #test to make sure it only works with a valid api key
    # json_payload = {
    #   ship_size: 2,
    #   start_space: "C1",
    #   end_space: "C2"
    # }.to_json
    #
    # headers = {"X-API-Key" => nil, "CONTENT_TYPE" => "application/json" }
    #
    # post "/api/v1/games/#{game.id}/ships", params: json_payload, headers: headers
    #
    # expect(response.status).to be(200)
    # expect(JSON.parse(response.body, symbolize_names: true)[:message]).to eq("Successfully placed ship with a size of 2. You have 0 ship(s) to place.")
    # expect(Game.last.player_1_board.board.third.first['C1'].contents).to_not be_a(Ship)

    json_payload = {
      ship_size: 2,
      start_space: "D1",
      end_space: "D2"
    }.to_json

    headers = {"X-API-Key" => user1.api_key, "CONTENT_TYPE" => "application/json" }

    post "/api/v1/games/#{game.id}/ships", params: json_payload, headers: headers

    expect(response.status).to be(200)
    expect(JSON.parse(response.body, symbolize_names: true)[:message]).to eq("Successfully placed ship with a size of 2. You have 0 ship(s) to place.")
    expect(Game.last.player_1_board.board.fourth.first['D1'].contents).to be_a(Ship)

    json_payload = {
      ship_size: 3,
      start_space: "B2",
      end_space: "B4"
    }.to_json
    headers = {"X-API-Key" => user2.api_key, "CONTENT_TYPE" => "application/json" }

    post "/api/v1/games/#{game.id}/ships", params: json_payload, headers: headers

    expect(response.status).to be(200)
    expect(JSON.parse(response.body, symbolize_names: true)[:message]).to eq("Successfully placed ship with a size of 3. You have 1 ship(s) to place with a size of 2.")
    expect(Game.last.player_2_board.board.second.second['B2'].contents).to be_a(Ship)

    json_payload = {
      ship_size: 2,
      start_space: "C1",
      end_space: "D1"
    }.to_json

    headers = {"X-API-Key" => user2.api_key, "CONTENT_TYPE" => "application/json" }

    post "/api/v1/games/#{game.id}/ships", params: json_payload, headers: headers

    expect(response.status).to be(200)
    expect(JSON.parse(response.body, symbolize_names: true)[:message]).to eq("Successfully placed ship with a size of 2. You have 0 ship(s) to place.")
    expect(Game.last.player_2_board.board.third.first['C1'].contents).to be_a(Ship)
  end
end
