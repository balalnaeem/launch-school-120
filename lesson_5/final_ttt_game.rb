class Board
  INITIAL_MARKER = " "
  WINNING_LINES = [
    [1, 2, 3], [4, 5, 6], [7, 8, 9], # rows
    [1, 4, 7], [2, 5, 8], [3, 6, 9], # columns
    [1, 5, 9], [3, 5, 7]             # diagonals
  ]

  attr_reader :squares

  def initialize
    @squares = {}
    reset
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts ""
    puts "     |     |     "
    puts "  #{squares[1]}  |  #{squares[2]}  |  #{squares[3]}  "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{squares[4]}  |  #{squares[5]}  |  #{squares[6]}  "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{squares[7]}  |  #{squares[8]}  |  #{squares[9]}  "
    puts "     |     |     "
    puts ""
  end
  # rubocop:enable Metrics/AbcSize

  def reset
    (1..9).each { |key| squares[key] = Square.new(INITIAL_MARKER) }
  end

  def []=(choice, marker)
    squares[choice].marker = marker
  end

  def full?
    squares.all? { |_, square| square.marked? }
  end

  def winning_marker
    WINNING_LINES.each do |line|
      next if line.any? { |key| squares[key].unmarked? }
      if line.map { |key| squares[key].marker }.uniq.size == 1
        return squares[line.first].marker
      end
    end
    nil
  end

  def someone_won?
    !!winning_marker
  end

  def empty_squares
    squares.select { |_, square| square.unmarked? }.keys
  end

  def square_in_danger
    WINNING_LINES.each do |line|
      if line.count { |key| squares[key].marked_by_human? } == 2
        if line.any? { |key| squares[key].unmarked? }
          return line.reject { |key| squares[key].marked? }.first
        end
      end
    end
    nil
  end

  def need_defence?
    !!square_in_danger
  end

  def winning_square
    WINNING_LINES.each do |line|
      if line.count { |key| squares[key].marker == 'O' } == 2
        if line.any? { |key| squares[key].unmarked? }
          return line.reject { |key| squares[key].marked? }.first
        end
      end
    end
    nil
  end

  def win_possible?
    !!winning_square
  end

  def square_5_empty?
    squares[5].unmarked?
  end
end

class Square
  attr_accessor :marker

  def initialize(marker)
    @marker = marker
  end

  def to_s
    marker
  end

  def marked?
    marker != Board::INITIAL_MARKER
  end

  def unmarked?
    marker == Board::INITIAL_MARKER
  end

  def marked_by_human?
    marker != 'O' && marked?
  end
end

class Player
  WINNING_SCORE = 5
  attr_reader :score, :name, :marker

  def initialize
    @score = 0
  end

  def increment_score
    @score += 1
  end

  def reset_score
    @score = 0
  end

  def grand_winner?
    score == WINNING_SCORE
  end
end

class Human < Player
  def initialize
    @name = ''
    @marker = ''
    super
  end

  def choose_name
    puts 'Please type your name below:'
    puts ''
    name_choice = ''
    loop do
      name_choice = gets.chomp
      break unless name_choice.empty?
      puts 'Sorry! You must enter at least one character. Try again.'
    end
    @name = name_choice
  end

  def choose_marker
    puts "Choose your marker. Enter an alphabet character other than 'O'."
    puts ''
    marker_choice = nil
    loop do
      marker_choice = gets.chomp.upcase
      break if marker_choice != 'O' && ('A'..'Z').cover?(marker_choice)
      puts 'Sorry. Invalid entry. Must enter an alphabet character.'
    end
    @marker = marker_choice
  end
end

class Computer < Player
  def initialize
    @name = ['Shazam', 'AiGod', 'SuperBot', 'TTT King', 'TheFazer'].sample
    @marker = 'O'
    super
  end
end

class TTTGame
  attr_reader :board, :human, :computer
  attr_writer :current_player, :first_mover

  def initialize
    @board = Board.new
    @human = Human.new
    @computer = Computer.new
  end

  def play
    ready_to_play
    loop do
      clear_screen_and_display_board
      loop do
        current_player_moves
        break if board.someone_won? || board.full?
        clear_screen_and_display_board
      end
      adjust_scores
      display_result
      announce_grand_winner
      break unless play_again?
    end
    display_goodbye_message
  end

  private

  def display_board
    puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    puts "You are #{human.marker}. #{computer.name} is #{computer.marker}."
    puts "Your score is #{human.score}. #{computer.name}'s score is #{computer.score}."
    puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    board.draw
  end

  def clear_screen
    system 'clear'
  end

  def clear_screen_and_display_board
    clear_screen
    display_board
  end

  def joinor(arr)
    return arr.first.to_s if arr.size == 1
    return "#{arr.first} and #{arr.last}" if arr.size == 2
    arr[-1] = "and #{arr.last}"
    arr.join(', ')
  end

  def display_welcome_message
    puts '########################################'
    puts ''
    puts "Welcome to Tic Tac Toe!"
    puts "You will be playing against #{computer.name}."
    puts "Grand Winning Score is #{Player::WINNING_SCORE}."
    puts ''
    puts '########################################'
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Bye!"
  end

  def decide_first_mover
    puts "Who would you like to go first? (h)uman or (c)omputer?"
    puts ''
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if %w(h c).include? answer
      puts "Sorry. Invalid answer. Muster enter h or c."
    end
    answer
  end

  def human_turn?
    @current_player == 'h'
  end

  def current_player_moves
    if human_turn?
      human_makes_move
      @current_player = 'c'
    else
      computer_makes_move
      @current_player = 'h'
    end
  end

  def human_makes_move
    puts "Pick a square from #{joinor(board.empty_squares)}"
    choice = nil
    loop do
      choice = gets.chomp.to_i
      break if board.empty_squares.include? choice
      puts "Sorry! Must enter valid input. Try again!"
    end
    board[choice] = human.marker
  end

  def computer_makes_move
    if board.win_possible?
      board[board.winning_square] = computer.marker
    elsif board.need_defence?
      board[board.square_in_danger] = computer.marker
    elsif board.square_5_empty?
      board[5] = computer.marker
    else
      board[board.empty_squares.sample] = computer.marker
    end
  end

  def display_result
    clear_screen_and_display_board
    result = case board.winning_marker
             when human.marker then "You have won!"
             when computer.marker then "#{computer.name} have won!"
             else "It's a tie!"
             end
    puts result
  end

  def adjust_scores
    if board.winning_marker == human.marker
      human.increment_score
    elsif board.winning_marker == computer.marker
      computer.increment_score
    end
  end

  def announce_grand_winner
    if human.grand_winner?
      puts "#{human.name} is the grand winner this time!"
      reset_both_scores
    elsif computer.grand_winner?
      puts "#{computer.name} is the grand winner this time!"
      reset_both_scores
    end
  end

  def reset_both_scores
    human.reset_score
    computer.reset_score
  end

  def reset
    board.reset
    @current_player = @first_mover
  end

  def play_again?
    puts 'Would you like to play again? (y/n)'
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry. Must enter y or n. Try again."
    end
    return false if answer == 'n'
    reset
    true
  end

  def ready_to_play
    clear_screen
    display_welcome_message
    human.choose_name
    human.choose_marker
    @first_mover = decide_first_mover
    @current_player = @first_mover
  end
end

TTTGame.new.play
