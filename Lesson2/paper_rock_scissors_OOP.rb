# simple cli based game of
# OOP version
# ROCK PAPER SCISSORS
CHOICES = { 'r' => 'Rock', 'p' => 'Paper', 's' => 'Scissors' }

class Player
  attr_accessor :games_won, :hand

  def set_random_hand
    self.hand = CHOICES.keys.sample
  end

  def gets_rps
    puts 'Paper, Rock, or Scissors?'
    choice = gets.chomp
    until CHOICES.keys.include?(choice)
      puts 'Invalid choice.  Enter Rock, Paper, or Scissors:'
      choice = gets.chomp
    end
    self.hand = choice
  end
end

class Game
  attr_accessor :user, :computer

  def initialize(user, computer)
    @user = user
    @computer = computer
    user.hand = nil
    computer.hand = nil
  end

  def show_winner
    if user.hand == computer.hand
      puts "You both chose #{CHOICES[user.hand]}\nIt's a tie!"
    elsif (user.hand == 'r' && computer.hand == 's') ||
          (user.hand == 'p' && computer.hand == 'r') ||
          (user.hand == 's' && computer.hand == 'p')
      describe_victory(user.hand)
      puts "User won!"
    else
      describe_victory(computer.hand)
      puts "Computer Won"
    end
  end

  def describe_victory(winning_hand)
    case winning_hand
    when 'r'
      puts 'Rock smashes Scissors'
    when 'p'
      puts 'Paper smothers Rock'
    when 's'
      puts 'Scissors shears Paper'
    end
  end
end

user = Player.new
computer = Player.new
loop do
  game = Game.new(user, computer)

  user.gets_rps
  computer.set_random_hand

  puts "Computer chose #{CHOICES[computer.hand]}"
  puts game.show_winner

  puts 'Play again? (Y/N)'
  break unless gets.chomp =~ /^[Yy]/
end

