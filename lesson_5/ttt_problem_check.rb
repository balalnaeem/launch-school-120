class Board
  MOST_STRATEGIC_POSITION = 5
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    @squares = {}
    reset
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def find_target_position(marker)
    WINNING_LINES.each do |line|
      markers = @squares.select do |k, v|
        line.include?(k) && v.marker == marker
      end
      unmarked_squares = @squares.values_at(*line).select(&:unmarked?)

      if markers.size == 2 && unmarked_squares.size == 1
        return (line - markers.keys).first
      end
    end

    nil
  end

  def offensive_move(computer_marker)
    find_target_position(computer_marker)
  end

  def defensive_move(human_marker)
    find_target_position(human_marker)
  end

  def strategic_move
    MOST_STRATEGIC_POSITION if unmarked_keys.include?(MOST_STRATEGIC_POSITION)
  end

  def random_move
    unmarked_keys.sample
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts '     |     |'
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts '     |     |'
    puts '-----+-----+-----'
    puts '     |     |'
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts '     |     |'
    puts '-----+-----+-----'
    puts '     |     |'
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts '     |     |'
  end
  # rubocop:enable Metrics/AbcSize

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).map(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = ' '

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def marked?
    marker != INITIAL_MARKER
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def to_s
    @marker
  end
end

class Player
  attr_reader :marker, :name
  attr_accessor :score

  def initialize
    @score = 0
  end
end

class Human < Player
  def initialize
    @name = choose_name
    @marker = choose_marker
    super
  end

  private

  def choose_name
    loop do
      puts "What's your name?"
      name = gets.chomp
      puts ''
      return name.strip unless name.match?(/^\s*$/)
      puts 'Sorry, please enter at least one non-whitespace character.'
    end
  end

  def choose_marker
    puts 'What would you like your marker to be?'
    loop do
      puts "Choose any single character except 'O', 'o' or whitespace."
      answer = gets.chomp
      puts ''
      return answer if answer.match?(/^[^\sOo]{1}$/)
      puts "Sorry, that's not a valid marker."
    end
  end
end

class Computer < Player
  def initialize
    @name = ['Terminator', 'Bender', 'R2D2'].sample
    @marker = 'O'
    super
  end
end

class TTTGame
  FIRST_MOVER = 'choose'
  WINNING_SCORE = 3

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @computer = Computer.new
    prepare_game
    @human = Human.new
    @current_marker = FIRST_MOVER
    establish_first_mover if FIRST_MOVER == 'choose'
  end

  def play
    loop do
      display_board

      loop do
        current_player_moves
        break if board.someone_won? || board.full?
        clear_screen_and_display_board if human_turn?
      end

      round_wrapup
      break if game_won? || !play_again?
      reset
      display_play_again_message
    end

    display_goodbye_message
  end

  private

  def prepare_game
    clear
    display_welcome_message
  end

  def display_welcome_message
    puts '***************************************************'
    puts 'Welcome to Tic Tac Toe!'
    puts "Your computer opponent today is #{computer.name}."
    puts "The first player to #{WINNING_SCORE} points is the overall winner."
    puts 'Good luck!!'
    puts '***************************************************'
    puts ''
  end

  def first_mover_choice
    loop do
      puts 'And who should go first? ((m)e, (c)omputer, or (e)ither)'
      answer = gets.chomp.downcase
      return answer if %w(m me c computer e either).include?(answer)
      puts "Sorry, that's an invalid answer."
    end
  end

  def establish_first_mover
    answer = first_mover_choice
    @current_marker = case answer
                      when 'm', 'me' then human.marker
                      when 'c', 'computer' then computer.marker
                      else [human.marker, computer.marker].sample
                      end
    @initial_current_marker = @current_marker
  end

  def display_goodbye_message
    if game_won?
      puts "And #{game_winner} is the overall winner - congratulations!"
    end
    puts ""
    puts "That's enough Tic Tac Toe for now!"
    puts 'Thanks for playing! Goodbye!'
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_markers
    puts ''
    puts "#{human.name} is #{human.marker}. " \
         "#{computer.name} is #{computer.marker}."
    puts ''
  end

  def display_score
    puts 'The current score is:'
    puts "#{human.name}: #{human.score}"
    puts "#{computer.name}: #{computer.score}"
  end

  def display_board
    display_markers
    display_score
    puts ''
    board.draw
    puts ''
  end

  def human_turn?
    @current_marker == human.marker
  end

  def joinor(arr)
    case arr.size
    when 1 then arr.first
    when 2 then arr.join(" or ")
    else
      arr[-1] = "or #{arr.last}"
      arr.join(", ")
    end
  end

  def human_moves
    puts "Choose a square (#{joinor(board.unmarked_keys)}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def computer_moves
    square = board.offensive_move(computer.marker) ||
             board.defensive_move(human.marker) ||
             board.strategic_move ||
             board.random_move

    board[square] = computer.marker
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = computer.marker
    else
      computer_moves
      @current_marker = human.marker
    end
  end

  def add_point
    human.score += 1 if board.winning_marker == human.marker
    computer.score += 1 if board.winning_marker == computer.marker
  end

  def game_won?
    human.score == WINNING_SCORE || computer.score == WINNING_SCORE
  end

  def game_winner
    human.score > computer.score ? human.name : computer.name
  end

  def round_wrapup
    add_point
    display_result
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      puts "#{human.name} won!"
    when computer.marker
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts 'Would you like to play again? (y/n)'
      answer = gets.chomp.downcase
      break if %w(y n yes no).include?(answer)
      puts 'Sorry, must be y or n.'
    end

    answer == 'y' || answer == 'yes'
  end

  def clear
    system('clear') || system('cls')
  end

  def reset
    board.reset
    @current_marker = @initial_current_marker
    clear
  end

  def display_play_again_message
    puts "And we're back!"
    puts ''
  end
end

TTTGame.new.play
