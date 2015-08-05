# simple cli based game of
# ROCK PAPER SCISSORS

#psuedo code:
#  prompt for p|r|s
#  random choose p|r|s for computer
#  determine win, lose, or draw
#  print results
#  ask for another game
#  repeat if yes

CHOICES = { 'r' => 'Rock', 'p' => 'Scissors', 's' => 'Scissors'}

def gets_rps
  puts "Paper, Rock, or Scissors?"
  choice = gets.chomp
  until CHOICES.keys.include?(choice)
    puts "Invalid choice.  Enter Rock, Paper, or Scissors:"
    choice = gets.chomp
  end
  choice
end

def show_winner(winner)
  case winner
    when 'r'
      puts 'Rock smashes Scissors'
    when 'p'
      puts 'Paper smothers Rock'
    when 's'
      puts 'Scissors shears Paper'
  end
end


loop do
  user_choice = gets_rps
  computer_choice = CHOICES.keys.sample

  if user_choice == computer_choice
    puts "You both chose #{user_choice}\nIt's a tie!"
  elsif (user_choice == 'r' && computer_choice == 's') ||
        (user_choice == 'p' && computer_choice == 'r') ||
        (user_choice == 's' && computer_choice == 'p')
    show_winner(user_choice)
    puts "User won!"
  else
    show_winner(computer_choice)
    puts "Computer Won"
  end
  
  puts "Play again? (Y/N)"
  break unless gets.chomp =~ /^[Yy]/
end

