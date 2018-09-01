class PlayerMoveCheck < ApplicationController
  def initialize(game, api_key, target)
    @game = game
    @api_key = api_key
    @target = target
  end

  def game_return
    game if api_key == game.player_1_key || api_key == game.player_2_key
  end

  def status_return
    if api_key != game.player_1_key && api_key != game.player_2_key
      401
    else
    current_turn_status
    end
  end

  def message_return
    if api_key != game.player_1_key && api_key != game.player_2_key
      return "Unauthorized"
    else
      current_turn_message
    end
  end

  private
  attr_reader :game, :api_key, :target
  
  def current_turn_status
    if game.current_turn == 'challenger' && api_key == game.player_1_key && game.winner == nil
      200
    elsif game.current_turn == 'opponent' && api_key == game.player_2_key && game.winner == nil
      200
    else
      400
    end
  end

  def current_turn_message
    if !game.winner.nil?
      "Invalid move. Game over."
    elsif  game.current_turn == 'challenger' && api_key == game.player_1_key
      turn_processor = TurnProcessor.new(game, target)
      turn_processor.run_player_1!
      turn_processor.message
    elsif game.current_turn == 'opponent' && api_key == game.player_2_key
      turn_processor = TurnProcessor.new(game, target)
      turn_processor.run_player_2!
      turn_processor.message
    elsif game.current_turn.nil?
      "Invalid move. Game over."
    else
      "Invalid move. It's your opponent's turn."
    end
  end
end
