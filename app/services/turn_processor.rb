class TurnProcessor
  def initialize(game, target)
    @game   = game
    @target = target
    @messages = []
  end

  def run_player_1!
    begin
      attack_opponent
      game.current_turn = 'opponent'
      game.save!
    rescue InvalidAttack => e
      @messages << e.message
    end
  end

  def run_player_2!
    begin
      attack_challenger
      game.current_turn = 'challenger'
      game.save!
    rescue InvalidAttack => e
      @messages << e.message
    end
  end

  def message
    @messages.join(" ")
  end

  private

  attr_reader :game, :target

  def attack_opponent
    result = Shooter.fire!(board: game.player_2_board, target: target)
    @messages << "Your shot resulted in a #{result}."
    if result == "Hit" && game.player_2_board.locate_space(target).contents.is_sunk?
      @messages << "Battleship sunk."
      game.update_attribute(:p1_kill_count, game.p1_kill_count += 1)
    end
    game.player_1_turns += 1
    if game.p1_kill_count == 2
      @messages << "Game over."
      winner_email = User.find_by_api_key(game.player_1_key).email
      game.update_attribute(:winner, winner_email)
      binding.pry
    end
  end

  def attack_challenger
    result = Shooter.fire!(board: game.player_1_board, target: target)
    @messages << "Your shot resulted in a #{result}."
    if result == "Hit" && game.player_1_board.locate_space(target).contents.is_sunk?
      @messages << "Battleship sunk."
      game.update_attribute(:p2_kill_count, game.p2_kill_count += 1)
    end
    game.player_2_turns += 1
    if game.p2_kill_count == 2
      @messages << "Game over."
    end
  end
end
