require 'rails_helper'

describe PlayerTurnCheck do
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
  it 'exists' do
    check = PlayerTurnCheck.new(@game, @user1.api_key, "A1")

    expect(check).to be_a(PlayerTurnCheck)
  end
  it 'will return the game if player api key is valid' do
    check = PlayerTurnCheck.new(@game, @user1.api_key, "A1")
    game = check.game_return

    expect(game.id).to eq(1)
    expect(game.player_1_board).to be_a(Board)
  end
  it 'will not return the game if player api key is invalid' do
    check = PlayerTurnCheck.new(@game, 'bobby', "A1")
    game = check.game_return

    expect(game).to eq(nil)
  end
  it 'will return a 401 status if invalid API key' do
    check = PlayerTurnCheck.new(@game, 'bobby', "A1")
    status = check.status_return

    expect(status).to eq(401)
  end
  it 'will return a 200 status if valid API key' do
    check1 = PlayerTurnCheck.new(@game, @user1.api_key, "A1")
    status1 = check1.status_return
    check1.message_return
    check2 = PlayerTurnCheck.new(@game, @user2.api_key, "A1")
    status2 = check2.status_return

    expect(status1).to eq(200)
    expect(status2).to eq(200)
  end
  it 'will return a 400 status if players attempt to go out of turn' do
    check = PlayerTurnCheck.new(@game, @user2.api_key, "A1")
    status = check.status_return

    expect(status).to eq(400)
  end
  it 'will return an unauthorized message if invalid API key' do
    check = PlayerTurnCheck.new(@game, 'bobby', "A1")
    message = check.message_return

    expect(message).to eq('Unauthorized')
  end
  it 'will return a hit message if shot matches ship location' do
    check = PlayerTurnCheck.new(@game, @user1.api_key, "D1")
    message = check.message_return

    expect(message).to include('Hit')
  end
  it 'will return a miss message if shot does not match ship location' do
    check = PlayerTurnCheck.new(@game, @user1.api_key, "A4")
    message = check.message_return

    expect(message).to include('Miss')
  end
  it 'will return an invalid message if player attempts to play out of turn' do
    check = PlayerTurnCheck.new(@game, @user2.api_key, "A4")
    message = check.message_return

    expect(message).to eq("Invalid move. It's your opponent's turn.")
  end
end


# describe "POST /api/v1/games/:id/shots" do
#   before :each do
#     @user1 = User.create(name: 'Angela', email: 'Bob@Bob.Bob', password: 'Bob', status: 1, api_key: SecureRandom.hex(32))
#     @user2 = User.create(name: 'JP', email: 'JP@Bob.Bob', password: 'JP', status: 1, api_key: SecureRandom.hex(32))
#     game_attributes = {
#       player_1_key: @user1.api_key,
#       player_2_key: @user2.api_key,
#       player_1_board: Board.new(4),
#       player_2_board: Board.new(4),
#       player_1_turns: 0,
#       player_2_turns: 0,
#       current_turn: "challenger"
#     }
#     @game = Game.create(game_attributes)
#     ShipPlacer.new(
#       board: @game.player_1_board,
#       ship: Ship.new(3),
#       start_space: "A1",
#       end_space: "A3"
#     ).run
#     ShipPlacer.new(
#       board: @game.player_2_board,
#       ship: Ship.new(3),
#       start_space: "D1",
#       end_space: "D3"
#     ).run
#     ShipPlacer.new(
#       board: @game.player_1_board,
#       ship: Ship.new(2),
#       start_space: "D3",
#       end_space: "D4"
#     ).run
#     ShipPlacer.new(
#       board: @game.player_2_board,
#       ship: Ship.new(2),
#       start_space: "B3",
#       end_space: "B4"
#     ).run
#     @game.update_attribute(:player_1_board, @game.player_1_board)
#     @game.update_attribute(:player_2_board, @game.player_2_board)
#   end
#   it 'can allow player 1 to fire if their turn' do
#     json_payload = {target: "D1"}.to_json
#     headers = {"X-API-Key" => @user1.api_key, "CONTENT_TYPE" => "application/json" }
#     post "/api/v1/games/#{@game.id}/shots", params: json_payload, headers: headers
#     game = JSON.parse(response.body, symbolize_names: true)
    
#     expect(response.status).to eq(200)
#     expect(game[:message]).to eq("Your shot resulted in a Hit.")
#   end
#   it 'can allow player 2 to fire if their turn' do
#     json_payload1 = {target: "D1"}.to_json
#     headers1 = {"X-API-Key" => @user1.api_key, "CONTENT_TYPE" => "application/json" }
#     post "/api/v1/games/#{@game.id}/shots", params: json_payload1, headers: headers1

#     json_payload2 = {target: "A1"}.to_json
#     headers2 = {"X-API-Key" => @user2.api_key, "CONTENT_TYPE" => "application/json" }
#     post "/api/v1/games/#{@game.id}/shots", params: json_payload2, headers: headers2
#     game = JSON.parse(response.body, symbolize_names: true)
    
#     expect(response.status).to eq(200)
#     expect(game[:message]).to eq("Your shot resulted in a Hit.")
#   end
#   it 'can stop the incorrect player from firing if not their turn' do
#     json_payload = {target: "D1"}.to_json
#     headers = {"X-API-Key" => @user2.api_key, "CONTENT_TYPE" => "application/json" }
#     post "/api/v1/games/#{@game.id}/shots", params: json_payload, headers: headers
#     game = JSON.parse(response.body, symbolize_names: true)
    
#     expect(response.status).to eq(200)
#     expect(game[:message]).to eq("Invalid move. It's your opponent's turn.")
#   end
#   it 'can stop a non-game involved user from firing' do
#     user3 = User.create(name: 'Jill', email: 'Jill@Bob.Bob', password: 'Jill', status: 1, api_key: SecureRandom.hex(32))

#     json_payload = {target: "D1"}.to_json
#     headers = {"X-API-Key" => user3.api_key, "CONTENT_TYPE" => "application/json" }
#     post "/api/v1/games/#{@game.id}/shots", params: json_payload, headers: headers
#     game = JSON.parse(response.body, symbolize_names: true)
    
#     expect(response.status).to eq(200)
#     expect(game[:message]).to eq("Unauthorized")
#   end
# end
