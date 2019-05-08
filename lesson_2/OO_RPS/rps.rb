require 'yaml'
MESSAGES = YAML.load_file('rps_config.yml')

module Displayable
  def clear_terminal
    system('clear') || system('cls')
  end
end

class Player
  attr_accessor :name, :move
  attr_reader :score

  def initialize
    @score = 0
    set_name
  end

  def increase_score
    @score += 1
  end

  def reset_score
    @score = 0
  end

  def to_s
    name
  end
end

class Human < Player
  def set_name
    name = nil

    loop do
      print MESSAGES['name_prompt']
      name = gets.chomp
      break unless name.strip.empty?
      puts MESSAGES['name_prompt_warning']
    end

    self.name = name
  end

  def choose
    choice = ''

    loop do
      puts "Choose one of the following: #{Move::MOVES_TO_DISPLAY}."
      print ">> "
      choice = gets.chomp.downcase
      choice = parse_choice(choice)
      break if Move::MOVES.include?(choice)
      puts "That wasn't a valid choice."
    end

    self.move = Move.get_move_from_string(choice)
  end

  private

  def parse_choice(choice)
    case choice
    when 'r' then 'rock'
    when 'p' then 'paper'
    when 'sc' then 'scissors'
    when 'sp' then 'spock'
    when 'l' then 'lizard'
    else choice
    end
  end
end

class Computer < Player
  ROBOTS = ['R2D2', 'WinnerBot', 'RandomBot', 'Hal']

  attr_reader :rounds, :move_preferences

  def initialize(rounds)
    super()
    @move_preferences = Hash.new(0)
    @rounds = rounds
    set_move_preferences
  end

  def set_name
    self.name = self.class.to_s
  end

  def choose
    self.move = Move.get_move_from_string(choose_move_from_preferences)
  end

  private

  def choose_move_from_preferences
    moves = []

    @move_preferences.each do |move, move_weight|
      move_weight.times { moves << move }
    end

    moves.sample
  end
end

class R2D2 < Computer
  protected

  def set_move_preferences
    @move_preferences = {
      'rock' => 1
    }
  end
end

class WinnerBot < Computer
  protected

  def set_move_preferences
    rounds_computer_won = rounds.select do |round|
      round['winner'] == self
    end

    winning_moves = rounds_computer_won.map do |round|
      round[name].to_s.downcase
    end

    Move::MOVES.each do |move|
      @move_preferences[move] = winning_moves.count(move) + 1
    end
  end
end

class RandomBot < Computer
  protected

  def set_move_preferences
    Move::MOVES.each do |move|
      @move_preferences[move] = 1
    end
  end
end

class Hal < Computer
  protected

  def set_move_preferences
    @move_preferences = {
      'rock'     => 2,
      'paper'    => 0,
      'scissors' => 10,
      'lizard'   => 1,
      'spock'    => 1
    }
  end
end

class Move
  MOVES = %w(rock paper scissors lizard spock)
  MOVES_TO_DISPLAY = "(r)ock, (p)aper, (sc)issors, (l)izard, or (sp)ock"

  def self.move_names
    MOVES.join(', ')
  end

  def self.get_move_from_string(string)
    Object.const_get(string.capitalize).new
  end

  def to_s
    self.class.to_s
  end
end

class Rock < Move
  def beat?(other_move)
    ['Scissors', 'Lizard'].include?(other_move.class.to_s)
  end
end

class Paper < Move
  def beat?(other_move)
    ['Rock', 'Spock'].include?(other_move.class.to_s)
  end
end

class Scissors < Move
  def beat?(other_move)
    ['Paper', 'Lizard'].include?(other_move.class.to_s)
  end
end

class Lizard < Move
  def beat?(other_move)
    ['Paper', 'Spock'].include?(other_move.class.to_s)
  end
end

class Spock < Move
  def beat?(other_move)
    ['Rock', 'Scissors'].include?(other_move.class.to_s)
  end
end

class Round
  include Displayable

  attr_reader :human, :computer, :winner

  def initialize(human, computer)
    @human = human
    @computer = computer
  end

  def play
    display_round_intro

    human.choose
    computer.choose
    set_winner
    winner&.increase_score unless winner.nil? # &. ==> safe nav operator

    clear_terminal
    display_moves
    display_winner

    round_results
  end

  private

  def display_round_intro
    puts MESSAGES['round_header']
  end

  def display_moves
    puts ""
    puts "#{human.name} chose #{human.move}!"
    puts "#{computer.name} chose #{computer.move}!"
    puts ""
  end

  def set_winner
    @winner = if human.move.beat?(computer.move)
                human
              elsif computer.move.beat?(human.move)
                computer
              end
  end

  def display_winner
    if winner.nil?
      puts "It's a tie!"
    else
      puts "#{winner.name} won!"
    end
    puts ""
  end

  def round_results
    {
      human.name => human.move,
      computer.name => computer.move,
      "winner" => winner.nil? ? nil : winner
    }
  end
end

class RPSGame
  include Displayable

  SCORE_TO_WIN = 10

  attr_accessor :human, :computer
  attr_reader :winner, :players, :rounds

  def initialize
    @rounds = []
    @players = []

    @human = Human.new
    @computer = choose_foe

    @players << human << computer
  end

  # Rubocop didn't like how many things this method was initially doing,
  # so I combined a few method calls into display_end_game & reset_game,
  # had Round.play return the result of the round instead of relying on
  # a separate call to Round.results, etc.
  def play
    display_welcome_message

    # Each game...
    loop do
      # Each round...
      loop do
        display_game_history unless rounds.empty?
        round_results = Round.new(human, computer).play
        @rounds << round_results
        break if winner?
      end

      set_winner
      display_end_game

      break unless play_again?
      reset_game
    end

    display_goodbye_message
  end

  private

  def choose_foe
    foe_name = Computer::ROBOTS.sample
    Object.const_get(foe_name).new(rounds)
  end

  def reset_scores
    @players.each(&:reset_score)
  end

  def reset_rounds
    @rounds.clear
  end

  def reset_game
    reset_scores
    reset_rounds
    clear_terminal
    display_welcome_message
  end

  def scores
    @players.each_with_object({}) do |player, scores|
      scores[player] = player.score
    end
  end

  def display_scores
    puts MESSAGES['score_intro']
    scores.each { |player, score| puts "  #{player.name}: #{score}" }
  end

  def winner?
    scores.value?(SCORE_TO_WIN)
  end

  def set_winner
    max_score = scores.values.max
    @winner = scores.values.count(max_score) > 1 ? nil : scores.key(max_score)
  end

  def display_welcome_message
    clear_terminal
    puts MESSAGES['welcome'] + "#{Move.move_names.upcase}!"
    puts "First player to #{RPSGame::SCORE_TO_WIN} wins!"
    puts "It's #{human.name} vs #{computer.name}. Ready?"
  end

  def display_goodbye_message
    puts MESSAGES['goodbye']
  end

  def display_round_history
    puts format("Round # %-10s %-10s Winner", human.name, computer.name)

    rounds.each_with_index do |round, index|
      puts format("%-7d %-10s %-10s %s", index + 1, round[human.name],
                  round[computer.name], round['winner'])
    end
  end

  def display_game_history
    display_scores
    puts
    display_round_history
    puts
  end

  def display_end_game
    puts
    display_round_history
    display_scores
    display_winner
  end

  def display_winner
    if winner.nil?
      puts "It's a tie!"
    else
      puts "#{winner.name} won!"
    end
    puts ""
  end

  def play_again?
    valid_inputs = %w(yes yup ya y nope no nah n)
    input = ''

    loop do
      puts MESSAGES['play_again_prompt']
      print ">> "
      input = gets.chomp.downcase
      break if valid_inputs.include?(input)
      puts MESSAGES['play_again_prompt_warning']
    end

    input.start_with?('y')
  end
end

RPSGame.new.play