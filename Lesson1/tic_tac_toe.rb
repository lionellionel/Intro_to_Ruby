#psuedo code
# array index 0-8
# initialized nil for all values
# set 1 if x , 0 if O
# define winning slices by index
#  [0,1,2],[3,4,5],[6,7,8],
#  [0,3,6],[1,4,7],[2,5,8]
#  [0,4,8],[2,4,6]

#  if slice.contains nil, no winner
#  if slice.all_values == 1 then x wins
#  if slice.all_values == 0 then o wins

# prompt for turn
# validate it's a correct input
# validate it's an empty space
# update grid
# print grid
# calculate winner?
# computer chooses
# update grid
# print grid
# calculate winner?
# until array has no nils
# else catseye

grid = Array.new(9)
# a nil value in grid represents an open space
# a 1 value represents a pip for the user (X)
# a 0 value represents a pip for the computer (O)

# slice is a list of sets of grid coordinates
#  that represent a "slice" i.e. line through the grid
slices = [
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
def update_grid(grid,coordinate,player)
  grid[coordinate] = player
end

# return a new tic-tac-toe grid
def simulate_grid(grid,coordinate,player)
  new_grid = grid.clone
  new_grid[coordinate] = player
  new_grid
end

def find_winner(grid,slices)
  slices.each do |slice| 
    #if grid has empty space, it can't be a winner
    next if [grid[slice[0]],grid[slice[1]],grid[slice[2]]].include?(nil)
    # if all equal, return winner
    if (grid[slice[0]] == grid[slice[1]]) && (grid[slice[1]] == grid[slice[2]] )
      return grid[slice[0]]
    end
  end
  nil
end

def computer_pick(grid,slices)
  open_spaces = grid.each_index.select{|x| grid[x].nil?}

  # look for winners
  open_spaces.each do |x|
    if find_winner(simulate_grid(grid,x,0),slices)
      puts "found #{x} for 0"
      return x
    end
  end

  # look for blocks
  open_spaces.each do |x|
    if find_winner(simulate_grid(grid,x,1),slices)
      puts "found #{x} for 1"
      return x
    end
  end

  # else pick from this order: center, corners, edges
  # Note: not a perfect algorithm - computer can be beat!
  [4,0,2,6,8,1,3,5,7].each do |x|
    return x if open_spaces.include?(x)
  end
  puts "shouldn't get here"
  nil

end


# MAIN
print_grid(grid)

until find_winner(grid,slices) || !grid.include?(nil) do
  user_choice = get_user_choice(grid)

  update_grid(grid,user_choice,1)
  print_grid(grid)
  break if find_winner(grid,slices) || !grid.include?(nil)

  puts "Computer goes:"
  update_grid(grid,computer_pick(grid,slices),0)
  print_grid(grid)

end

case find_winner(grid,slices)
  when 1
    puts "Hey you won!"
  when 0
    puts "You've been beat!"
  else
    puts "Looks like a cats-eye"
end
