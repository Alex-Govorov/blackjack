class Deck
  attr_reader :cards

  def initialize
    generate
    shuffle
  end

  private

  def generate
    @cards = []
    Card::SUITS.each do |suit|
      Card::VALUES.each { |value| @cards << Card.new(suit, value) }
    end
  end

  def shuffle
    @cards.shuffle!
  end
end
