class Card
  attr_reader :suit, :rank

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def rank_value
    case rank
    when 'Ace'   then 14
    when 'King'  then 13
    when 'Queen' then 12
    when 'Jack'  then 11
    else rank
    end
  end

  def suit_value
    case suit
    when 'Diamonds' then 1
    when 'Clubs'    then 2
    when 'Hearts'   then 3
    else 4
    end
  end

  def <=>(other_card)
    if rank_value == other_card.rank_value
      suit_value <=> other_card.suit_value
    else
      rank_value <=> other_card.rank_value
    end
  end

  def ==(other_card)
    rank_value == other_card.rank_value && suit == other_card.suit
  end

  def to_s
    "#{rank} of #{suit}"
  end
end

class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze

  attr_reader :cards

  def initialize
    @cards = []
    reset
  end

  def reset
    SUITS.each do |suit|
      RANKS.each do |rank|
        cards << Card.new(rank, suit)
      end
    end
    cards.shuffle!
  end

  def draw
    reset if cards.empty?
    cards.pop
  end
end
