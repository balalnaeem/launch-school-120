=begin
  What is the Rule?
    any move that's causing the most losses, will be ignored.
=end

module WiseUp
  def worst_moves(arr)
    lost_hands = arr.select { |a, b| b == :lost}.map(&:first)
    if lost_hands.uniq == lost_hands
      lost_hands.first
    else
      lost_hands.max_by { |move| lost_hands.count(move) }
    end
  end
end

class Player
  include WiseUp
  MOVES = ['rock', 'paper', 'scissors', 'lizard', 'spock']
  WINNING_COMBO = {
    'rock'     => ['scissors', 'lizard'],
    'paper'    => ['rock', 'spock'],
    'scissors' => ['paper', 'lizard'],
    'lizard'   => ['spock', 'paper'],
    'spock'    => ['scissors', 'rock']
  }
  attr_accessor :nickname, :move, :score, :moves_history

  def initialize
    set_nickname
    @score = 0
    @moves_history = []
  end

  def won?(other_player)
    WINNING_COMBO.each do |k, v|
      return true if move == k && v.include?(other_player.move)
    end
    false
  end
end

class Human < Player
  def set_nickname
    puts "Choose a nickname:"
    answer = ''
    loop do
      answer = gets.chomp
      break unless answer.empty?
      puts "Invalid input. Please enter a value"
    end
    self.nickname = answer
  end

  def choose
    puts "Choose one from rock, paper, scissors, lizard and spock."
    choice = ''
    loop do
      choice = gets.chomp
      break if Player::MOVES.include? choice
      puts "Sorry. Invalid input. Try again."
    end
    self.move = choice
  end
end

class Computer < Player
  def set_nickname
    self.nickname = ['Shazam', 'LoveBots', 'AiGod', 'MacOG', 'BatComp'].sample
  end

  def choose
    loop do
      self.move = Player::MOVES.sample
      break unless move == worst_moves(moves_history)
    end
  end
end

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_msg
    puts "Welcome to Rock, Paper, Scissors, Lizard, Spock #{human.nickname}!"
    puts "You are playing against #{computer.nickname}."
  end

  def display_goodbye_msg
    puts "Thanks for playing! Goodbye!"
  end

  def announce_winner
    puts "**********"
    if human.won?(computer)
      human.moves_history << [human.move, :won]
      computer.moves_history << [computer.move, :lost]
      human.score += 1
      puts "You won!"
    elsif computer.won?(human)
      computer.moves_history << [computer.move, :won]
      human.moves_history << [human.move, :lost]
      puts "#{computer.nickname} won!"
      computer.score +=1
    else
      computer.moves_history << [computer.move, :tie]
      human.moves_history << [human.move, :tie]
      puts "It's a tie"
    end
    puts "**********"
  end

  def announce_score
    puts ''
    puts "Your score is #{human.score}."
    puts "#{computer.nickname}'s score is #{computer.score}."
    puts ''
  end

  def announce_grand_winner
    if human.score == 5
      puts "*** Your are the grand winner of this round! ***"
      human.score = 0
      computer.score = 0
    else
      puts "*** #{computer.nickname} is the grand winner of this round! ***"
      human.score = 0
      computer.score = 0
    end
    puts ''
    puts "Your moves history so far: #{human.moves_history}."
    puts "#{computer.nickname}'s moves history so far: #{computer.moves_history}."
  end

  def display_moves
    puts ''
    puts "You chose #{human.move}."
    puts "#{computer.nickname} chose #{computer.move}."
    puts ''
  end

  def play_again?
    puts "Would you like to play again? (y/n)"
    answer = ''
    loop do
      answer = gets.chomp.downcase
      break if %w(n y).include? answer
      puts "Sorry. Invalid answer. Please enter y or n."
    end
    answer == 'y' ? true : false
  end

  def play
    display_welcome_msg
    loop do
      loop do
        human.choose
        computer.choose
        display_moves
        announce_winner
        announce_score
        break if human.score == 5 || computer.score == 5
      end
      announce_grand_winner
      break unless play_again?
    end
    display_goodbye_msg
  end
end

RPSGame.new.play