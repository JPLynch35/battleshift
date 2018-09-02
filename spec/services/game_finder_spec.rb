require 'rails_helper'

describe GameFinder do
  before :each do
    @user1 = User.create(name: 'Angela', email: 'Bob@Bob.Bob', password: 'Bob', status: 1, api_key: SecureRandom.hex(32))
    @user2 = User.create(name: 'JP', email: 'JP@Bob.Bob', password: 'JP', status: 1, api_key: SecureRandom.hex(32))
    @user3 = User.create(name: 'Jill', email: 'Jill@Bob.Bob', password: 'Jill', status: 1, api_key: SecureRandom.hex(32))
    player_1_board = Board.new(4)
    player_2_board = Board.new(4)
    game1_attributes = {
                    player_1_board: player_1_board,
                    player_2_board: player_2_board,
                    player_1_turns: 0,
                    player_2_turns: 0,
                    current_turn: "challenger",
                    player_1_key: @user1.api_key,
                    player_2_key: @user2.api_key
                  }
    @game1 = Game.new(game1_attributes)
    @game1.save!
    game2_attributes = {
                    player_1_board: player_1_board,
                    player_2_board: player_2_board,
                    player_1_turns: 0,
                    player_2_turns: 0,
                    current_turn: "challenger",
                    player_1_key: @user2.api_key,
                    player_2_key: @user3.api_key
                  }
    @game2 = Game.new(game2_attributes)
    @game2.save!
  end
  it 'limits user to only interact with games using their API key' do
    game_finder = GameFinder.new(1, @user1.api_key)
    game = game_finder.retrieve_game
    
    expect(game.id).to eq(@game1.id)
  end
end
