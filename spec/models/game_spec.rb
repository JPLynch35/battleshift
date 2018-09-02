require 'rails_helper'

RSpec.describe Game, type: :model do
  fixtures :games

  it 'exists' do
    # game_attributes = {
    #   player_1_key: "dhf8972y3wenfdsfdsjfs",
    #   player_2_key: "sdkljfo87y32nsdfdsf93",
    #   player_1_board: Board.new(4),
    #   player_2_board: Board.new(4),
    #   player_1_turns: 0,
    #   player_2_turns: 0,
    #   current_turn: "challenger"
    # }
    # game = Game.create(game_attributes)
    game = games(:game1)

    expect(game).to be_a(Game)
  end
  it 'has attributes' do
    game_attributes = {
      player_1_key: "dhf8972y3wenfdsfdsjfs",
      player_2_key: "sdkljfo87y32nsdfdsf93",
      player_1_board: Board.new(4),
      player_2_board: Board.new(4),
      player_1_turns: 0,
      player_2_turns: 0,
      current_turn: "challenger"
    }
    game = Game.create(game_attributes)

    expect(game.player_1_key).to eq("dhf8972y3wenfdsfdsjfs")
    expect(game.player_2_key).to eq("sdkljfo87y32nsdfdsf93")
    expect(game.player_1_board).to be_a(Board)
    expect(game.player_2_board).to be_a(Board)
    expect(game.player_1_turns).to eq(0)
    expect(game.player_2_turns).to eq(0)
    expect(game.current_turn).to eq("challenger")
  end
end
