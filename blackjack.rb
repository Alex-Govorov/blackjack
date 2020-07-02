class BlackJack
  attr_reader :player, :dealer, :game_account, :open, :winner

  def initialize(player_name)
    @player = Player.new(player_name)
    @dealer = Dealer.new('Дилер')
    @game_account = Account.new
    @deck = Deck.new
  end

  def start
    game_reset if @open == true
    deck_replacement if deck_empty?
    deal_initial_cards
    make_bets
    player_turn
  end

  def show_hand_value(player)
    return if player.name == 'Дилер' && @open.nil?

    player.hand.value
  end

  def show_hand(player)
    cards = player.hand.cards_with_suit
    cards.each_with_object([]) do |card, hand|
      card = '*' if player.name == 'Дилер' && @open.nil?
      hand << card
    end
  end

  def pass
    dealer_turn
  end

  def add_card
    @player.hand.take_card_from_deck(@deck) if @player.hand.cards.count == 2
    dealer_turn
  end

  def open_cards
    @open = true
    reward_the_winner
  end

  private

  def deck_empty?
    true if @deck.cards.count < 6
  end

  def deck_replacement
    @deck = Deck.new
  end

  def deal_initial_cards
    2.times { @player.hand.take_card_from_deck(@deck) }
    2.times { @dealer.hand.take_card_from_deck(@deck) }
  end

  def make_bets
    @player.account.transfer_to(@game_account, 10)
    @dealer.account.transfer_to(@game_account, 10)
  end

  def player_turn
    open_cards?
  end

  def dealer_turn
    @dealer.decide(@deck)
    player_turn
  end

  def open_cards?
    open_cards if @player.hand.cards.count == 3 && @dealer.hand.cards.count == 3
  end

  def who_win?
    @winner = winner_is unless @player.hand.value == @dealer.hand.value
  end

  def winner_is
    if (@player.hand.value <= 21 && @player.hand.value > @dealer.hand.value) ||
       (@dealer.hand.value > 21 && @player.hand.value <= 21)
      @player
    elsif @dealer.hand.value <= 21
      @dealer
    end
  end

  def reward_the_winner
    @winner = who_win?
    if @winner.nil?
      money_back
    else
      @game_account.transfer_to(@winner.account, @game_account.amount)
    end
  end

  def money_back
    @game_account.transfer_to(@player.account, @game_account.amount / 2)
    @game_account.transfer_to(@dealer.account, @game_account.amount)
  end

  def game_reset
    @player.hand.drop_cards
    @dealer.hand.drop_cards
    @open = nil
  end
end
