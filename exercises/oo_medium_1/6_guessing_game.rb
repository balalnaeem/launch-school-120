class GuessingGame
  def intialize
    @guesses_left = nil
    @number_to_guess = nil
  end

  def play
    @guesses_left = 7
    @number_to_guess = rand(1..100)
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

  def human_guesses
    answer = nil
    loop do
      puts "Enter a number between 1 and 100"
      answer = gets.chomp.to_i
      break if (1..100).to_a.include?(answer)
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
