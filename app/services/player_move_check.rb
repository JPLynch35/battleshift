class PlayerMoveCheck < ApplicationController
  def initialize(game_id, api_key, target)
    @game = GameFinder.new(game_id, api_key).retrieve_game
    @api_key = api_key
    @target = target
  end

  def game_return
    if game.nil?
      {message: "Unauthorized"}.to_json
    else
      game
    end
  end

  def status_return
    if game.nil?
      401
    else
      current_turn_status
    end
  end

  def message_return
    if game.nil?
      nil
    else
      current_turn_message
    end
  end

  private
  attr_reader :game, :api_key, :target
  
  def current_turn_status
    if game.current_turn == 'challenger' && api_key == game.player_1_key && game.winner == nil && game.player_1_board.space_names.include?(target)
      200
    elsif game.current_turn == 'opponent' && api_key == game.player_2_key && game.winner == nil && game.player_1_board.space_names.include?(target)
      200
    else
      400
    end
  end

  def current_turn_message
    if !game.winner.nil?
      "Invalid move. Game over."
    elsif !game.player_1_board.space_names.include?(target)
      "Invalid coordinates."
    elsif  game.current_turn == 'challenger' && api_key == game.player_1_key
      turn_processor = TurnProcessor.new(game, target)
      turn_processor.run_player_1!
      turn_processor.message
    elsif game.current_turn == 'opponent' && api_key == game.player_2_key
      turn_processor = TurnProcessor.new(game, target)
      turn_processor.run_player_2!
      turn_processor.message
    else
      "Invalid move. It's your opponent's turn."
    end
  end
end
