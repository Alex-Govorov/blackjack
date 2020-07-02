class Card
  attr_reader :suit, :value

  SUITS = ['♠', '♥', '♦', '♣'].freeze
  VALUES = [*(2..10), 'J', 'Q', 'K', 'A'].freeze

  def initialize(suit, value)
    @suit = suit
    @value = value
  end
end
