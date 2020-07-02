class Interface
  attr_reader :game

  MENU_METHODS = { 1 => :pass, 2 => :add_card, 3 => :open_cards }.freeze

  def initialize
    player_setup
    @game = BlackJack.new(@player_name)
  end

  def start_game
    @game.start
    game_cycle
    hud
    @game.winner ? winner_message : draw_message
    try_again?
  end

  def game_cycle
    hud
    menu
    game_cycle unless @game.open == true
  end

  def winner_message
    puts "Победитель: #{@game.winner.name}"
  end

  def draw_message
    puts 'Ничья, деньги возвращаются игрокам'
  end

  def player_setup
    puts 'Введите ваше имя:'
    @player_name = gets.chomp
  end

  def hud
    puts "
    В банке: #{@game.game_account.amount}$
    #{@game.player.name}: #{@game.player.account.amount}$
    #{@game.dealer.name}: #{@game.dealer.account.amount}$
    -------------
    Карты #{@game.player.name}: #{@game.show_hand(@game.player)}
    Сумма очков: #{@game.show_hand_value(@game.player)}
    -------------
    Карты #{@game.dealer.name}: #{@game.show_hand(@game.dealer)}
    Сумма очков: #{@game.show_hand_value(@game.dealer)}
    "
  end

  def menu
    puts 'Ваш ход:'
    puts '1. Пропустить'
    puts '2. Добавить карту' if @game.player.hand.cards.count == 2
    puts '3. Открыть карты'
    choice = gets.chomp.to_i
    @game.send(MENU_METHODS[choice])
  end

  def try_again?
    puts "Хотите сыграть еще раз?
    1. Да
    2. Нет"
    choice = gets.chomp.to_i
    case choice
    when 1
      start_game
    when 2
      puts 'Повезет в следующий раз'
      exit
    end
  end
end
