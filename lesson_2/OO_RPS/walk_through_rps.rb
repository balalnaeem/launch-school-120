class Move
  VALUES = ['rock', 'paper', 'scissors']
  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def to_s
    @value
  end

  def >(other_move)
    (rock? && other_move.scissors?) ||
      (paper? && other_move.rock?) ||
      (scissors? && other_move.paper?)
  end
end

class Player
  attr_accessor :move, :player_name

  def initialize
    set_name
  end
end

class Human < Player
  def set_name
    name_answer = ''
    loop do
      puts 'Please enter your name:'
      name_answer = gets.chomp
      break unless name_answer.empty?
      puts "Sorry! Please enter a value."
    end
    self.player_name = name_answer
  end

  def choose
    choice = nil
    loop do
      puts "please choose rock, paper or scissors:"
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts "Sorry. Invalid choice."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.player_name = %w(cheeda meeda maja jaka).sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

# Game Orchestration Engine
class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors #{human.player_name}!"
  end

  def display_choices
    puts "#{human.player_name} chose #{human.move}."
    puts "#{computer.player_name} chose #{computer.move}."
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.player_name} won!"
    elsif computer.move > human.move
      puts "#{computer.player_name} won!"
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would #{human.player_name} like to play again?(y/n)"
      answer = gets.chomp
      break if %w(y n).include?(answer)
      puts "Sorry! Please enter 'y' or 'n'."
    end
    return false if answer == 'n'
    true
  end

  def display_goodbye_message
    puts "Thanks for playing. Good bye!"
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose
      display_choices
      display_winner
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
