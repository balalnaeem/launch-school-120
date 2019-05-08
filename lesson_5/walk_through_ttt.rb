
class Board
  WINNING_LINES = [
    [1, 2, 3], [4, 5, 6], [7, 8, 9], # rows
    [1, 4, 7], [2, 5, 8], [3, 6, 9], # columns
    [1, 5, 9], [3, 5, 7] # diagonals
  ]
  attr_reader :squares
  def initialize
    @squares = {}
    reset
  end

  def []=(key, player_marker)
    squares[key].marker = player_marker
  end

  def unmarked_squares
    squares.select { |_, square| square.unmarked? }.keys
  end

  def full?
    unmarked_squares.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def square_in_danger
    WINNING_LINES.each do |line|
      if line.count { |key| squares[key].marker == TTTGame::HUMAN_MARKER } == 2
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
      if line.count { |key| squares[key].marker == TTTGame::COMPUTER_MARKER } == 2
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

  # rubocop:disable Metrics/LineLength
  def winning_marker
    WINNING_LINES.each do |line|
      if line.all? { |k| squares[k].marked? }
        if squares.values_at(*line).map(&:to_s).uniq.size == 1
          return squares[line.first].to_s
        end
      end
      # if line.all? { |key| squares[key].marker == TTTGame::HUMAN_MARKER }
      #   return TTTGame::HUMAN_MARKER
      # elsif line.all? { |key| squares[key].marker == TTTGame::COMPUTER_MARKER }
      #   return TTTGame::COMPUTER_MARKER
      # end
    end
    nil
  end

  # def winning_marker
  #   WINNING_LINES.each do |line|
  #     squares = @squares.values_at(*line)
  #     if three_identical_markers?(squares)
  #       return squares.first.marker
  #     end
  #   end
  #   nil
  # end

  # def three_identical_markers?(squares)
  #   markers = squares.select(&:marked?).collect(&:marker)
  #   return false if markers.size != 3
  #   markers.min == markers.max
  # end
  # rubocop:enable Metrics/LineLength

  def reset
    (1..9).each { |key| squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts "     |     |  "
    puts "  #{squares[1]}  |  #{squares[2]}  |  #{squares[3]}"
    puts '     |     |  '
    puts '-----+-----+-----'
    puts '     |     |  '
    puts "  #{squares[4]}  |  #{squares[5]}  |  #{squares[6]}"
    puts '     |     |  '
    puts '-----+-----+-----'
    puts '     |     |  '
    puts "  #{squares[7]}  |  #{squares[8]}  |  #{squares[9]}"
    puts '     |     |  '
  end
  # rubocop:enable Metrics/AbcSize
end

class Square
  INITIAL_MARKER = ' '
  attr_accessor :marker
  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_reader :marker, :score
  def initialize(marker)
    @marker = marker
    @score = 0
  end

  def increment_score
    @score += 1
  end

  def reset_score
    @score = 0
  end
end

class TTTGame
  COMPUTER_MARKER = 'O'
  HUMAN_MARKER = 'X'

  attr_reader :board, :human, :computer, :current_marker, :first_to_move

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
  end

  private

  def clear
    system 'clear'
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
  end

  def display_goodbye_message
    puts "Thanks for playing. Goodbye!"
  end

  def display_board
    puts "You are #{human.marker}. Computer is #{computer.marker}."
    puts "Your score: #{human.score}. Computer's score: #{computer.score}."
    puts ""
    board.draw
    puts ""
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def joinor(arr, delimiter=', ', word='and')
    if arr.size == 1
      arr.first
    elsif arr.size == 2
      "#{arr.first} #{word} #{arr.last}"
    else
      arr[-1] = "#{word} #{arr.last}"
      arr.join(delimiter)
    end
  end

  def human_moves
    puts "Please choose a square from (#{joinor(board.unmarked_squares)}):"
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_squares.include? square
      puts "Invalid number. Try again."
    end
    board[square] = HUMAN_MARKER
  end

  def computer_moves
    if board.win_possible?
      board[board.winning_square] = computer.marker
    elsif board.need_defence?
      board[board.square_in_danger] = computer.marker
    elsif board.square_5_empty?
      board[5] = computer.marker
    else
      board[board.unmarked_squares.sample] = computer.marker
    end
  end

  def choose_turn
    puts "Who would you like to go first? (h = human or c = computer)?"
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if %w(h c).include? answer
      puts "Sorry. Invalid answer. Must enter 'h' or 'c'."
    end
    if answer == 'h'
      @first_to_move = HUMAN_MARKER
      @current_marker = HUMAN_MARKER
    else
      @first_to_move = COMPUTER_MARKER
      @current_marker = COMPUTER_MARKER
    end
  end

  def human_turn?
    @current_marker == HUMAN_MARKER
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = COMPUTER_MARKER
    else
      computer_moves
      @current_marker = HUMAN_MARKER
    end
  end

  def adjust_scores
    if board.winning_marker == HUMAN_MARKER
      human.increment_score
    elsif board.winning_marker == COMPUTER_MARKER
      computer.increment_score
    end
  end

  def display_result
    clear_screen_and_display_board
    result = case board.winning_marker
             when HUMAN_MARKER then "You won!"
             when COMPUTER_MARKER then "Computer won!"
             else "It's a tie!"
             end
    puts result
  end

  def announce_grand_winner
    if human.score == 5
      puts "You are the grand winner!"
    elsif computer.score == 5
      puts "Computer is the grand winner!"
    end
  end

  def play_again?
    puts "Would you like to play again?"
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry. Must enter y or n."
    end
    answer == 'y'
  end

  def reset_board
    @current_marker = first_to_move
    board.reset
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end

  def prepare_game
    clear
    display_welcome_message
    choose_turn
  end

  def total_reset
    human.reset_score
    computer.reset_score
    reset_board
    clear
    display_play_again_message
  end

  public

  def play
    prepare_game
    loop do
      display_board
      loop do
        loop do
          current_player_moves
          break if board.full? || board.someone_won?
          clear_screen_and_display_board
        end
        adjust_scores
        display_result
        reset_board
        break if human.score == 5 || computer.score == 5
      end
      announce_grand_winner
      break unless play_again?
      total_reset
    end
    display_goodbye_message
  end
end

game = TTTGame.new
game.play
