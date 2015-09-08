# Blackjack OOP version

FACES = ['2','3','4','5','6','7','8','9','10','A','J','Q','K']
SUITS = ['H','C','D','S']

class Deck
  attr_accessor :cards

  def initialize(size)
    @cards =[]
    size.times do 
      FACES.each do |face|
        SUITS.each do |suit|
          @cards << Card.new(face,suit)
        end
      end      
    end 
    @cards.shuffle!     
  end

  def deal
    @cards.pop
  end

end

class Card
  attr_accessor :face, :suit

  def initialize(face,suit)
    @face = face
    @suit = suit
  end

  def to_s
    suit_unicode = case suit
                   when 'H'
                    "\u2661"
                   when 'C'
                    "\u2667"
                   when 'D'
                    "\u2662"
                   when 'S'
                    "\u2664"
                   end
    "#{face}#{suit_unicode}"
  end
end

module Handable
  def add_to_hand(card)
    hand << card
  end

  def show_hand
    print "---- #{name}'s Hand ----\n=>   "
    hand.each do|card|
      print "#{card}  "
    end
    puts "    Total: #{total}"
  end

  def total
    faces = hand.map{|card| card.face }

    total = 0
    faces.each do |val|
      if val == "A"
        total += 11
      else
        total += (val.to_i == 0 ? 10 : val.to_i)
      end
    end

    #correct for Aces
    faces.select{|val| val == "A"}.count.times do
      break if total <= 21
      total -= 10
    end

    total
  end

  def is_busted?
    total > 21
  end

end


class Player
  include Handable
  attr_accessor :name, :hand

  def initialize
    puts "What's your name?"
    @name = gets.chomp
    @hand = []
  end

  def show_flop
    show_hand
  end
end

class Dealer
  include Handable
  attr_accessor :name, :hand

  def initialize
    @name = "Dealer"
    @hand = []
  end

  def show_flop
    print "---- #{name}'s Hand ----\n=>   "
      print "XX  "
      print "#{hand[1]}  "
    puts "    Total: ??"
  end
end

class Blackjack
  attr_accessor :deck, :player, :dealer

  BLACKJACK_AMOUNT = 21
  DEALER_HIT_MIN = 17
  SHOE_SIZE = 2

  def initialize
    @deck = Deck.new(SHOE_SIZE)
    @player = Player.new
    @dealer = Dealer.new
  end

  def deal_cards
    player.add_to_hand(deck.deal)
    dealer.add_to_hand(deck.deal)
    player.add_to_hand(deck.deal)
    dealer.add_to_hand(deck.deal)
  end

  def show_flop
    player.show_flop
    dealer.show_flop
  end

  def blackjack_or_bust?(player_or_dealer)
    if player_or_dealer.total == BLACKJACK_AMOUNT
      if player_or_dealer.is_a?(Dealer)
        puts "Sorry, dealer hit blackjack. #{player.name} loses."
      else
        puts "Congratulations, you hit blackjack! #{player.name} win!"
      end
      play_again?
    elsif player_or_dealer.is_busted?
      if player_or_dealer.is_a?(Dealer)
        puts "Congratulations, dealer busted. #{player.name} win!"
      else
        puts "Sorry, #{player.name} busted. #{player.name} loses."
      end
      play_again?
    end
  end

  def player_turn
    puts "\n#{player.name}'s turn."

    blackjack_or_bust?(player)

    while !player.is_busted?
      puts "What would you like to do? 1) hit 2) stay"
      response = gets.chomp

      if !['1', '2'].include?(response)
        puts "Error: you must enter 1 or 2"
        next
      end

      if response == '2'
        puts "#{player.name} chose to stay."
        break
      end

      new_card = deck.deal
      puts "Dealing card to #{player.name}: #{new_card}"
      player.add_to_hand(new_card)
      puts "#{player.name}'s total is now: #{player.total}"

      blackjack_or_bust?(player)
    end
    puts "#{player.name} stays at #{player.total}."
  end

  def dealer_turn
    print "\n"
    dealer.show_hand

    blackjack_or_bust?(dealer)
    while dealer.total < DEALER_HIT_MIN
      new_card = deck.deal
      sleep 1
      puts "Dealer hits: #{new_card}"
      dealer.add_to_hand(new_card)
      blackjack_or_bust?(dealer)
    end
    sleep 1
    puts "Dealer stays at #{dealer.total}."
  end

  def who_won?
    if player.total > dealer.total
      puts "Congratulations, #{player.name} wins!"
    elsif player.total < dealer.total
      puts "Sorry, #{player.name} loses."
    else
      puts "It's a tie!"
    end
    play_again?
  end

  def play_again?
    puts ""
    puts "Would you like to play again? 1) yes 2) no, exit"
    if gets.chomp == '1'
      puts "Starting new game..."
      puts ""
      system('clear')
     
      if deck.cards.size < 18*SHOE_SIZE
        self.deck = Deck.new(SHOE_SIZE)
        puts "Too few cards left.  Shuffling a new shoe of #{52*SHOE_SIZE} cards"
        sleep 4
      end
      player.hand = []
      dealer.hand = []
      start
    else
      puts "Goodbye!"
      exit
    end
  end

  def start
    deal_cards
    show_flop
    player_turn
    dealer_turn
    who_won?
  end
end

game = Blackjack.new
game.start
