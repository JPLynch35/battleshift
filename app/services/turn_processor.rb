class TurnProcessor
  def initialize(game, target)
    @game   = game
    @target = target
    @messages = []
  end

  def run_player_1!
    # begin
      attack(game.player_2_board, game.p1_kill_count, game.player_1_key)
      game.current_turn = 'opponent'
      game.player_1_turns += 1
      game.save!
    # rescue InvalidAttack => e
    #   @messages << e.message
    # end
  end

  def run_player_2!
    # begin
      attack(game.player_1_board, game.p2_kill_count, game.player_2_key)
      game.current_turn = 'challenger'
      game.player_2_turns += 1
      game.save!
    # rescue InvalidAttack => e
    #   @messages << e.message
    # end
  end

  def message
    @messages.join(" ")
  end

  private

  attr_reader :game, :target

  def attack(p_board, p_kill_count, p_key)
    result = Shooter.fire!(board: p_board, target: target)
    @messages << "Your shot resulted in a #{result}."
    (p_kill_count += 1) if sunk_check(result, p_board, p_key, p_kill_count)
    game_over_check(p_kill_count, p_key)
  end

  def sunk_check(result, p_board, p_key, p_kill_count)
    if result == "Hit" && p_board.locate_space(target).contents.is_sunk?
      @messages << "Battleship sunk."
      if p_key == game.player_1_key
        game.update_attribute(:p1_kill_count, p_kill_count += 1)
      else
        game.update_attribute(:p2_kill_count, p_kill_count += 1)
      end
      return true
    end
    return false
  end

  def game_over_check(p_kill_count, p_key)
    if p_kill_count == 2
      @messages << "Game over."
      winner_email = User.find_by_api_key(p_key).email
      game.update_attribute(:winner, winner_email)
    end
  end

end
