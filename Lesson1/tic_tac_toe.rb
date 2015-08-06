#Tick Tack Toe Game 

grid = Array.new(9)
# a nil value in grid represents an open space
# a 1 value represents a pip for the user (X)
# a 0 value represents a pip for the computer (O)

# a slice is a set of grid coordinates that
# represents a line going through 3 squares in the grid
SLICES = [
  [0,1,2],[3,4,5],[6,7,8],
  [0,3,6],[1,4,7],[2,5,8],
  [0,4,8],[2,4,6]
  ]

def print_grid(grid)
  # map grid to pip character for display purposes
  grid_display = 
    grid.map do |pip|
      if pip == 1
        "X"
      elsif pip == 0
        "O"
      else
        " "
      end
    end

  system 'clear'
  puts "     |     |     "
  puts "  #{grid_display[0]}  |  #{grid_display[1]}  |  #{grid_display[2]}  "
  puts "     |     |     "
  puts "-----+-----+-----"
  puts "     |     |     "
  puts "  #{grid_display[3]}  |  #{grid_display[4]}  |  #{grid_display[5]}  "
  puts "     |     |     "
  puts "-----+-----+-----"
  puts "     |     |     "
  puts "  #{grid_display[6]}  |  #{grid_display[7]}  |  #{grid_display[8]}  "
  puts "     |     |     \n"
end

def get_user_choice(grid)
  puts "Enter coordinate 1-9"
  choice = gets.chomp.to_i - 1
  until (0..8).include?(choice) && grid[choice].nil?
    puts "Invalid choice.  Choose an available space"
    choice = gets.chomp.to_i - 1
  end
  choice
end

# Update tic-tac-toe grid (destructive method)
def update_grid(grid, coordinate, player)
  grid[coordinate] = player
end

# return a new tic-tac-toe grid
def simulate_grid(grid, coordinate, player)
  new_grid = grid.clone
  new_grid[coordinate] = player
  new_grid
end

def find_winner(grid)
  SLICES.each do |slice| 
    pips_in_slice = slice.map{|coordinate| grid[coordinate]}
    #if slice has empty space, it can't be a winner
    next if pips_in_slice.include?(nil)
    # if all equal, return winner
    return pips_in_slice[0] if pips_in_slice.uniq.length == 1
  end
  nil
end

def computer_pick(grid)
  open_spaces = grid.each_index.select{|coordinate| grid[coordinate].nil?}

  # look for winners
  open_spaces.each do |coordinate|
    if find_winner(simulate_grid(grid, coordinate, 0))
      return coordinate 
    end
  end

  # look for blocks
  open_spaces.each do |coordinate|
    if find_winner(simulate_grid(grid, coordinate, 1))
      return coordinate
    end
  end

  # else pick from this order: center, corners, edges
  # Note: not a perfect algorithm - computer can be beat!
  [4,0,2,6,8,1,3,5,7].each do |coordinate|
    return coordinate if open_spaces.include?(coordinate)
  end
  nil

end


# MAIN
print_grid(grid)

until find_winner(grid) || !grid.include?(nil) do
  user_choice = get_user_choice(grid)

  update_grid(grid,user_choice,1)
  print_grid(grid)
  break if find_winner(grid) || !grid.include?(nil)

  puts "Computer goes:"
  update_grid(grid, computer_pick(grid), 0)
  print_grid(grid)

end

case find_winner(grid)
when 1
  puts "Hey you won!"
when 0
  puts "You've been beat!"
else
  puts "Looks like a cats-eye"
end
