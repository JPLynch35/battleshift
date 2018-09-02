require 'rails_helper'

describe PlayerMoveCheck do
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
    check = PlayerMoveCheck.new(@game, @user1.api_key, "A1")

    expect(check).to be_a(PlayerMoveCheck)
  end
  it 'will return the game if player api key is valid' do
    check = PlayerMoveCheck.new(@game, @user1.api_key, "A1")
    game = check.game_return

    expect(game.id).to eq(1)
    expect(game.player_1_board).to be_a(Board)
  end
  it 'will not return the game if player api key is invalid' do
    check = PlayerMoveCheck.new(@game, 'bobby', "A1")
    game = check.game_return

    expect(game).to eq(nil)
  end
  it 'will return a 401 status if invalid API key' do
    check = PlayerMoveCheck.new(@game, 'bobby', "A1")
    status = check.status_return

    expect(status).to eq(401)
  end
  it 'will return a 200 status if valid API key' do
    check1 = PlayerMoveCheck.new(@game, @user1.api_key, "A1")
    status1 = check1.status_return
    check1.message_return
    check2 = PlayerMoveCheck.new(@game, @user2.api_key, "A1")
    status2 = check2.status_return

    expect(status1).to eq(200)
    expect(status2).to eq(200)
  end
  it 'will return a 400 status if players attempt to go out of turn' do
    check = PlayerMoveCheck.new(@game, @user2.api_key, "A1")
    status = check.status_return

    expect(status).to eq(400)
  end
  it 'will return an unauthorized message if invalid API key' do
    check = PlayerMoveCheck.new(@game, 'bobby', "A1")
    message = check.message_return

    expect(message).to eq('Unauthorized')
  end
  it 'will return a hit message if shot matches ship location' do
    check = PlayerMoveCheck.new(@game, @user1.api_key, "D1")
    message = check.message_return

    expect(message).to include('Hit')
  end
  it 'will return a miss message if shot does not match ship location' do
    check = PlayerMoveCheck.new(@game, @user1.api_key, "A4")
    message = check.message_return

    expect(message).to include('Miss')
  end
  it 'will return an invalid message if player attempts to play out of turn' do
    check = PlayerMoveCheck.new(@game, @user2.api_key, "A4")
    message = check.message_return

    expect(message).to eq("Invalid move. It's your opponent's turn.")
  end
  it 'will return a invalid message if player attempts to play after game over' do
    check1 = PlayerMoveCheck.new(@game, @user1.api_key, "D1")
    check1.message_return
    check2 = PlayerMoveCheck.new(@game, @user2.api_key, "A1")
    check2.message_return
    check3 = PlayerMoveCheck.new(@game, @user1.api_key, "D2")
    check3.message_return
    check4 = PlayerMoveCheck.new(@game, @user2.api_key, "A2")
    check4.message_return
    check5 = PlayerMoveCheck.new(@game, @user1.api_key, "D3")
    check5.message_return
    check6 = PlayerMoveCheck.new(@game, @user2.api_key, "A3")
    check6.message_return
    check7 = PlayerMoveCheck.new(@game, @user1.api_key, "B3")
    check7.message_return
    check8 = PlayerMoveCheck.new(@game, @user2.api_key, "A4")
    check8.message_return
    check9 = PlayerMoveCheck.new(@game, @user1.api_key, "B4")
    check9.message_return
    last_move = PlayerMoveCheck.new(@game, @user2.api_key, "A4")

    status = last_move.status_return
    message = last_move.message_return

    expect(status).to eq(400)
    expect(message).to eq("Invalid move. Game over.")
  end
  it 'will return an invalid message if shot is not on board' do
    check = PlayerMoveCheck.new(@game, @user1.api_key, "E1")
    status = check.status_return
    message = check.message_return

    expect(status).to eq(400)
    expect(message).to eq("Invalid coordinates.")
  end
end
