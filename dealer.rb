class Dealer < Player
  def decide(deck)
    hand.take_card_from_deck(deck) if hand.value <= 17 && hand.cards.count < 3
  end
end
