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
    ShipPlacer.new(
      board: @game.player_1_board,
      ship: Ship.new(3),
      start_space: "A1",
      end_space: "A3"
    ).run
    ShipPlacer.new(
      board: @game.player_2_board,
      ship: Ship.new(3),
      start_space: "D1",
      end_space: "D3"
    ).run
    ShipPlacer.new(
      board: @game.player_1_board,
      ship: Ship.new(2),
      start_space: "D3",
      end_space: "D4"
    ).run
    ShipPlacer.new(
      board: @game.player_2_board,
      ship: Ship.new(2),
      start_space: "B3",
      end_space: "B4"
    ).run
    @game.update_attribute(:player_1_board, @game.player_1_board)
    @game.update_attribute(:player_2_board, @game.player_2_board)
  end
  it 'can play a full game' do
    #hits
    endpoint = "/api/v1/games/#{@game_id}/shots"
    json_payload = {target: "D1"}.to_json
    headers = {"X-API-Key" => @user1.api_key, "CONTENT_TYPE" => "application/json" }
    post "/api/v1/games/#{@game.id}/shots", params: json_payload, headers: headers

    result = JSON.parse(response.body)
    expect(result['message']).to eq('Your shot resulted in a Hit.')

    endpoint = "/api/v1/games/#{@game_id}/shots"
    json_payload = {target: "A1"}.to_json
    headers = {"X-API-Key" => @user2.api_key, "CONTENT_TYPE" => "application/json" }
    post "/api/v1/games/#{@game.id}/shots", params: json_payload, headers: headers

    result = JSON.parse(response.body)
    expect(result['message']).to eq('Your shot resulted in a Hit.')

    #misses
    endpoint = "/api/v1/games/#{@game_id}/shots"
    json_payload = {target: "C1"}.to_json
    headers = {"X-API-Key" => @user1.api_key, "CONTENT_TYPE" => "application/json" }
    post "/api/v1/games/#{@game.id}/shots", params: json_payload, headers: headers

    result = JSON.parse(response.body)
    expect(result['message']).to eq('Your shot resulted in a Miss.')

    endpoint = "/api/v1/games/#{@game_id}/shots"
    json_payload = {target: "C1"}.to_json
    headers = {"X-API-Key" => @user2.api_key, "CONTENT_TYPE" => "application/json" }
    post "/api/v1/games/#{@game.id}/shots", params: json_payload, headers: headers

    result = JSON.parse(response.body)
    expect(result['message']).to eq('Your shot resulted in a Miss.')

    #invalid board spaces
    endpoint = "/api/v1/games/#{@game_id}/shots"
    json_payload = {target: "E1"}.to_json
    headers = {"X-API-Key" => @user1.api_key, "CONTENT_TYPE" => "application/json" }
    post "/api/v1/games/#{@game.id}/shots", params: json_payload, headers: headers

    result = JSON.parse(response.body)
    expect(result['message']).to eq('Invalid coordinates.')

    #hits
    endpoint = "/api/v1/games/#{@game_id}/shots"
    json_payload = {target: "D2"}.to_json
    headers = {"X-API-Key" => @user1.api_key, "CONTENT_TYPE" => "application/json" }
    post "/api/v1/games/#{@game.id}/shots", params: json_payload, headers: headers

    result = JSON.parse(response.body)
    expect(result['message']).to eq('Your shot resulted in a Hit.')

    endpoint = "/api/v1/games/#{@game_id}/shots"
    json_payload = {target: "A2"}.to_json
    headers = {"X-API-Key" => @user2.api_key, "CONTENT_TYPE" => "application/json" }
    post "/api/v1/games/#{@game.id}/shots", params: json_payload, headers: headers

    result = JSON.parse(response.body)
    expect(result['message']).to eq('Your shot resulted in a Hit.')

    #sink ships
    endpoint = "/api/v1/games/#{@game_id}/shots"
    json_payload = {target: "D3"}.to_json
    headers = {"X-API-Key" => @user1.api_key, "CONTENT_TYPE" => "application/json" }
    post "/api/v1/games/#{@game.id}/shots", params: json_payload, headers: headers

    result = JSON.parse(response.body)
    expect(result['message']).to eq('Your shot resulted in a Hit. Battleship sunk.')

    endpoint = "/api/v1/games/#{@game_id}/shots"
    json_payload = {target: "A3"}.to_json
    headers = {"X-API-Key" => @user2.api_key, "CONTENT_TYPE" => "application/json" }
    post "/api/v1/games/#{@game.id}/shots", params: json_payload, headers: headers

    result = JSON.parse(response.body)
    expect(result['message']).to eq('Your shot resulted in a Hit. Battleship sunk.')

    #wrong turn
    endpoint = "/api/v1/games/#{@game_id}/shots"
    json_payload = {target: "A4"}.to_json
    headers = {"X-API-Key" => @user2.api_key, "CONTENT_TYPE" => "application/json" }
    post "/api/v1/games/#{@game.id}/shots", params: json_payload, headers: headers

    result = JSON.parse(response.body)
    expect(result['message']).to eq("Invalid move. It's your opponent's turn.")

    #hit
    endpoint = "/api/v1/games/#{@game_id}/shots"
    json_payload = {target: "B3"}.to_json
    headers = {"X-API-Key" => @user1.api_key, "CONTENT_TYPE" => "application/json" }
    post "/api/v1/games/#{@game.id}/shots", params: json_payload, headers: headers

    result = JSON.parse(response.body)
    expect(result['message']).to eq('Your shot resulted in a Hit.')

    #miss
    endpoint = "/api/v1/games/#{@game_id}/shots"
    json_payload = {target: "B4"}.to_json
    headers = {"X-API-Key" => @user2.api_key, "CONTENT_TYPE" => "application/json" }
    post "/api/v1/games/#{@game.id}/shots", params: json_payload, headers: headers

    result = JSON.parse(response.body)
    expect(result['message']).to eq('Your shot resulted in a Miss.')

    #sink ship and win game
    endpoint = "/api/v1/games/#{@game_id}/shots"
    json_payload = {target: "B4"}.to_json
    headers = {"X-API-Key" => @user1.api_key, "CONTENT_TYPE" => "application/json" }
    post "/api/v1/games/#{@game.id}/shots", params: json_payload, headers: headers

    result = JSON.parse(response.body)
    expect(result['message']).to eq('Your shot resulted in a Hit. Battleship sunk. Game over.')
    expect(result['winner']).to eq(@user1.email)

    #try to play after winner
    endpoint = "/api/v1/games/#{@game_id}/shots"
    json_payload = {target: "D4"}.to_json
    headers = {"X-API-Key" => @user2.api_key, "CONTENT_TYPE" => "application/json" }
    post "/api/v1/games/#{@game.id}/shots", params: json_payload, headers: headers

    result = JSON.parse(response.body)
    expect(result['message']).to eq('Invalid move. Game over.')
  end
end
