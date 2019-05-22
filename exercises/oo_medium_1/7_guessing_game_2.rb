class GuessingGame
  def intialize
    @lower_limit = nil
    @upper_limit = nil
    @guesses_left = nil
    @number_to_guess = nil
  end

  def play
    @lower_limit = obtain_lower_limit
    @upper_limit = obtain_upper_limit
    @range = (@lower_limit..@upper_limit)
    @guesses_left = Math.log2(@upper_limit-@lower_limit).to_i + 1
    @number_to_guess = rand(@range)
    answer = nil

    loop do
      display_guesses_left
      answer = human_guesses
      check_answer(answer)
      break if answer == @number_to_guess
      @guesses_left -= 1
      break if @guesses_left == 0
    end
    puts
    puts
    announce_result(answer)
  end

  private

  def obtain_lower_limit
    puts "What number would you like to start the range from?"
    answer = nil
    loop do
      answer = gets.chomp.to_i
      break if answer > 1
      puts "You have to enter a positive number! Try again"
    end
    answer
  end

  def obtain_upper_limit
    puts "What number would you like to end the range at?"
    answer = nil
    loop do
      answer = gets.chomp.to_i
      break if answer > @lower_limit
      puts "You have to enter a number bigger than lower limit. Try again!"
    end
    answer
  end

  def human_guesses
    answer = nil
    loop do
      puts "Enter a number between #{@lower_limit} and #{@upper_limit}."
      answer = gets.chomp.to_i
      break if (@range).to_a.include?(answer)
      puts "Invalid guess!"
    end
    answer
  end

  def display_guesses_left
    puts "You have #{@guesses_left} guesses remaining."
  end

  def check_answer(answer)
    if answer == @number_to_guess
      puts "That's the number!"
    elsif answer < @number_to_guess
      puts "Your guess is too low!"
    else
      puts "Your guess is too high!"
    end
  end

  def announce_result(answer)
    if answer == @number_to_guess
      puts "You won!"
    else
      puts "No more guesses! You have lost!"
    end
  end
end

game = GuessingGame.new
game.play
