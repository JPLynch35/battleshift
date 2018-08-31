require 'rails_helper'

describe "Api::V1::Shots" do
  context "POST /api/v1/games/:id/shots" do
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

    it "updates the message and board with a hit" do
      ShipPlacer.new(
        board: @game.player_2_board,
        ship: Ship.new(3),
        start_space: "A1",
        end_space: "A3"
      ).run
      @game.update_attribute(:player_2_board, @game.player_2_board)

      headers = {"X-API-Key" => @user1.api_key, "CONTENT_TYPE" => "application/json" }
      json_payload = {target: "A1"}.to_json

      post "/api/v1/games/#{@game.id}/shots", params: json_payload, headers: headers

      expect(response).to be_success

      game = JSON.parse(response.body, symbolize_names: true)

      expected_messages = "Your shot resulted in a Hit."
      player_2_targeted_space = game[:player_2_board][:rows].first[:data].first[:status]


      expect(game[:message]).to eq expected_messages
      expect(player_2_targeted_space).to eq("Hit")
    end

    it "updates the message and board with a miss" do
      ShipPlacer.new(
        board: @game.player_2_board,
        ship: Ship.new(3),
        start_space: "D1",
        end_space: "D3"
      ).run
      @game.update_attribute(:player_2_board, @game.player_2_board)

      headers = {"X-API-Key" => @user1.api_key, "CONTENT_TYPE" => "application/json" }
      json_payload = {target: "A1"}.to_json

      post "/api/v1/games/#{@game.id}/shots", params: json_payload, headers: headers

      expect(response).to be_success

      game = JSON.parse(response.body, symbolize_names: true)

      expected_messages = "Your shot resulted in a Miss."
      player_2_targeted_space = game[:player_2_board][:rows].first[:data].first[:status]


      expect(game[:message]).to eq expected_messages
      expect(player_2_targeted_space).to eq("Miss")
    end

    it "updates the message but not the board with invalid coordinates" do
      headers = {"X-API-Key" => @user1.api_key, "CONTENT_TYPE" => "application/json" }
      json_payload = {target: "E1"}.to_json
      post "/api/v1/games/#{@game.id}/shots", params: json_payload, headers: headers

      game = JSON.parse(response.body, symbolize_names: true)
      expect(game[:message]).to eq "Invalid coordinates."
    end
  end
end
