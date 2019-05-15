module Displayable
  def display_welcome_message
    clear
    puts "Welcome to 21, #{player.name}!"
    puts ''
    puts "You will be playing against #{dealer.name} today!"
  end

  def display_goodbye_message
    puts "Thank you for playing! Goodbye!"
  end

  def clear
    system('clear') || system('cls')
  end

  def display_busted_message
    if player.busted?
      puts "Looks like you are busted! #{dealer.name} is the winner!"
    elsif dealer.busted?
      dealer.display_hand
      puts "Looks like #{dealer.name} is busted! You are the winner!"
    end
  end

  def display_initial_cards
    player.display_hand
    dealer.display_initial_hand
  end

  def display_final_hands
    player.display_hand
    dealer.display_hand
  end

  def display_game_result
    result = if player.total > dealer.total
               "Looks like you are the winner, #{player.name}!"
             elsif dealer.total > player.total
               "Looks like #{dealer.name} is the winner!"
             else
               "It's a tie!"
             end
    puts result
  end

  def display_hand
    puts ''
    puts "******** #{name}'s Hand ********"
    hand.each_with_index do |card, idx|
      puts "#{idx + 1} : The #{card.value} of #{card.suit}"
    end
    puts "Total value: #{total}"
    puts ''
  end

  def display_initial_hand
    puts "******** #{name}'s Hand ********"
    hand.each_with_index do |card, idx|
      if idx == 0
        puts "#{idx + 1} : The #{card.value} of #{card.suit}"
      else
        puts "#{idx + 1}: Unknown"
      end
    end
    puts ''
  end

  def display_black_jack_win
    puts "WOW! You hit a Black Jack. You won!"
  end
end

module Hand
  BLACK_JACK = 21

  def total
    total_val = 0
    values.each do |v|
      card_value = if ['Jack', 'King', 'Queen'].include?(v)
                     10
                   elsif v.is_a? Integer
                     v
                   else
                     11
                   end
      total_val += card_value
    end
    values.count('Ace').times do
      total_val -= 10 if total_val > BLACK_JACK
    end
    total_val
  end

  def busted?
    total > 21
  end

  def reset_hand
    @hand = []
  end

  def values
    hand.map(&:value)
  end

  def blackjack?
    total == BLACK_JACK
  end
end

class Participant
  include Hand
  include Displayable

  attr_reader :hand, :name

  def initialize
    @hand = []
  end

  def hit_or_stay
    puts "Would you like to hit or stay? (h/s)"
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if ['h', 's'].include?(answer)
      puts "Sorry! Invalid choice. Please enter 'h' or 's'."
    end
    answer
  end

  def chose_hit?
    hit_or_stay == 'h'
  end
end

class Player < Participant
  def initialize
    @name = choose_name
    super
  end

  private

  def choose_name
    puts "What's your name?"
    choice = nil
    loop do
      choice = gets.chomp
      break if choice =~ /[a-z]/i
      puts "Please enter at least one aphabet character."
    end
    choice
  end
end

class Dealer < Participant
  def initialize
    @name = choose_name
    super
  end

  private

  def choose_name
    @name = ['AiGod', 'BotKing', 'TimApple', 'MacNinja', 'DonaldTrump'].sample
  end
end

class Card
  attr_reader :suit, :value

  def initialize(suit, value)
    @suit = suit
    @value = value
  end
end

class Deck
  SUITS = ['Hearts', 'Diamonds', 'Spades', 'Clubs']
  VALUES = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'Queen', 'King', 'Ace']

  attr_reader :cards

  def initialize
    reset
  end

  def reset
    @cards = []
    SUITS.each do |suit|
      VALUES.each do |value|
        cards << Card.new(suit, value)
      end
    end
    @cards = cards.shuffle
  end
end

class Game
  DEALER_MAX_TOTAL = 17
  include Displayable
  attr_reader :deck, :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def start
    display_welcome_message
    loop do
      deal_initial_cards
      display_initial_cards
      play
      break unless play_again?
      reset_game
      clear
    end
    display_goodbye_message
  end

  private

  def deal_initial_cards
    2.times do
      player.hand << deck.cards.pop
      dealer.hand << deck.cards.pop
    end
  end

  def add_card(current_player = :dealer)
    if current_player == :dealer
      dealer.hand << deck.cards.pop
    else
      player.hand << deck.cards.pop
    end
  end

  def player_turn
    loop do
      break if player.blackjack?
      if player.chose_hit?
        puts "#{player.name} chose to hit..."
        add_card(:player)
        player.display_hand
      else
        puts "#{player.name} chose to stay..."
        break
      end
      break if player.busted?
    end
  end

  def dealer_turn
    puts ''
    puts "#{dealer.name}'s' turn..."
    puts ''
    loop do
      if dealer.total < DEALER_MAX_TOTAL
        puts "He chose hit..."
        add_card
      else
        puts "He chooses stay this time..."
        break
      end
      break if dealer.busted?
    end
  end

  def hit_loop
    loop do
      player_turn
      display_black_jack_win if player.blackjack?
      break if player.blackjack?

      if player.busted?
        display_busted_message
        break
      end

      dealer_turn
      if dealer.busted?
        display_busted_message
        break
      end

      break
    end
  end

  def play
    loop do
      hit_loop
      break if player.blackjack? || player.busted? || dealer.busted?
      display_final_hands
      display_game_result
      break
    end
  end

  def play_again?
    puts "Would you like to play again? (y/n)"
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if ['y', 'n'].include? answer
      puts "Sorry, invalid answer! Please enter y or n."
    end
    answer == 'y'
  end

  def reset_game
    deck.reset
    player.reset_hand
    dealer.reset_hand
  end
end

game = Game.new
game.start
