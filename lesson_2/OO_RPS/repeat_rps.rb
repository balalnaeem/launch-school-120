class Player
  attr_accessor :move, :name, :score, :history

  def initialize
    set_name
    @score = 0
    @history = []
  end
end

class Human < Player
  def set_name
    answer = ''
    loop do
      puts "Enter you name below:"
      answer = gets.chomp
      break unless answer.empty?
      puts "Please enter some value."
    end
    self.name = answer
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, scissors, lizard or spock"
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts "Invalid choice. Try again."
    end
    self.history << choice
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['Batman', 'Shazam', 'Superman', 'Terminator', 'bot-bot'].sample
  end

  def choose
    choice = Move::VALUES.sample
    self.move = Move.new(choice)
    self.history << choice
  end
end

class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

  def initialize(value)
    @value = value
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def scissors?
    @value == 'scissors'
  end

  def lizard?
    @value == 'lizard'
  end

  def spock?
    @value == 'spock'
  end

  def >(other_move)
    (rock? && (other_move.scissors? || other_move.lizard?)) ||
      (paper? && (other_move.rock? || other_move.spock?)) ||
      (scissors? && (other_move.paper? || other_move.lizard?)) ||
      (lizard? && (other_move.spock? || other_move.paper?)) ||
      (spock? && (other_move.scissors? || other_move.rock?))
  end

  def to_s
    @value
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
    puts "Welcome to Rock, Paper, Scissors, Lizard and Spock #{human.name}!"
  end

  def display_goodbye_message
    puts "Thanks for playing. Goodbye!"
  end

  def display_choices
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}"
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won"
      human.score += 1
    elsif computer.move > human.move
      puts "#{computer.name} won!"
      computer.score += 1
    else
      puts "It's a tie!"
    end
  end

  def display_scores
    puts "#{human.name}'s score = #{human.score}"
    puts "#{computer.name}'s score = #{computer.score}"

    if human.score == 5
      puts "#{human.name} is the grand winner!"
    elsif computer.score == 5
      puts "#{computer.name} is the grand winner!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again?(y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
      puts "Invalid answer."
    end
    answer == 'y' ? true : false
  end

  def play
    display_welcome_message
    loop do
      loop do
        human.choose
        computer.choose
        display_choices
        display_winner
        display_scores
        break if human.score >= 5 || computer.score >= 5
      end
      human.score = 0
      computer.score = 0
      break unless play_again?
    end
    display_goodbye_message
    puts "Your moves record: #{human.history}"
    puts "Computer's moves record: #{computer.history}"
  end
end

RPSGame.new.play
