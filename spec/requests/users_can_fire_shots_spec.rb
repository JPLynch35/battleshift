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
    @game.update_attribute(:player_1_board, @game.player_1_board)
    @game.update_attribute(:player_2_board, @game.player_2_board)
  end
  it 'player 1 and player 2 can fire a shot and hit' do
    json_payload = {target: "D1"}.to_json
    headers = {"X-API-Key" => @user1.api_key, "CONTENT_TYPE" => "application/json" }
    post "/api/v1/games/#{@game.id}/shots", params: json_payload, headers: headers
    expect(response.status).to eq(200)
    expect(JSON.parse(response.body, symbolize_names: true)[:message]).to include("Your shot resulted in a Hit")
    expect(Game.last.player_2_board.board.last.first['D1'].status).to eq("Hit")
    expect(Game.last[:winner]).to be_nil

    json_payload = {target: "A1"}.to_json
    headers = {"X-API-Key" => @user2.api_key, "CONTENT_TYPE" => "application/json" }
    post "/api/v1/games/#{@game.id}/shots", params: json_payload, headers: headers

    expect(response.status).to eq(200)
    expect(JSON.parse(response.body, symbolize_names: true)[:message]).to include("Your shot resulted in a Hit")
    expect(Game.last.player_1_board.board.first.first['A1'].status).to eq("Hit")
    expect(Game.last[:winner]).to be_nil
  end
  it 'player 1 can fire a shot and miss' do
    json_payload = {target: "B1"}.to_json
    headers = {"X-API-Key" => @user1.api_key, "CONTENT_TYPE" => "application/json" }
    post "/api/v1/games/#{@game.id}/shots", params: json_payload, headers: headers

    expect(response.status).to eq(200)
    expect(JSON.parse(response.body, symbolize_names: true)[:message]).to include("Your shot resulted in a Miss")
    expect(Game.last.player_2_board.board.second.first['B1'].status).to eq("Miss")
    expect(Game.last[:winner]).to be_nil

    json_payload = {target: "B1"}.to_json
    headers = {"X-API-Key" => @user2.api_key, "CONTENT_TYPE" => "application/json" }
    post "/api/v1/games/#{@game.id}/shots", params: json_payload, headers: headers

    expect(response.status).to eq(200)
    expect(JSON.parse(response.body, symbolize_names: true)[:message]).to include("Your shot resulted in a Miss")
    expect(Game.last.player_2_board.board.second.first['B1'].status).to eq("Miss")
    expect(Game.last[:winner]).to be_nil
  end
end
