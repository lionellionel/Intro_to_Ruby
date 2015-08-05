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

# slice is a list of sets of grid coordinates
#  that represent a "slice" i.e. line through the grid
slices = [
  [0,1,2],[3,4,5],[6,7,8],
  [0,3,6],[1,4,7],[2,5,8],
  [0,4,8],[2,4,6]
  ]

def print_grid(grid)
  #for display map grid to pip character 
  grid_display = grid.map do |pip|
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
    #   ugh fix this!  next if grid[slice.include?(nil)
    #next if grid[slice.include?(nil)
    if (grid[slice[0]] == grid[slice[1]]) && (grid[slice[1]] == grid[slice[2]] )
      return grid[slice[0]] unless grid[slice[0]].nil?
    end
  end
  nil
end

def computer_pick(grid,slices)
  open_spaces = grid.each_index.select{|x| grid[x].nil?}
  open_spaces.each do |x|
    if find_winner(simulate_grid(grid,x,1),slices)
      puts "found #{x}"
      return x
    end
    if find_winner(simulate_grid(grid,x,0),slices)
      puts "found #{x}"
      return x
    end
  end
  [4,0,2,6,8,1,3,5,7].each do |x|
    return x if open_spaces.include?(x)
  end
  puts "not here"
  nil


end


#print_grid(grid)
#grid[3]=1
#grid[4]=0
print_grid(grid)
until find_winner(grid,slices) || !grid.include?(nil) do
  user_choice = get_user_choice(grid)
  puts "user chose #{user_choice}"
  sample = simulate_grid(grid,user_choice,1)
  print_grid(sample)
  puts "that was the sample"

  update_grid(grid,user_choice,1)
  print_grid(grid)
  puts "winner?: #{find_winner(grid,slices)}"
  break if find_winner(grid,slices) || !grid.include?(nil)

puts "pick"
  puts computer_pick(grid,slices)

  puts "Computer goes:"
  #update_grid(grid,grid.each_index.select{|x| grid[x].nil?}.sample,0)
  update_grid(grid,computer_pick(grid,slices),0)
  print_grid(grid)
  puts "winner?: #{find_winner(grid,slices)}"

end
puts find_winner(grid,slices)
#print_grid(grid)
#user_choice = get_user_choice(grid)
#puts user_choice
#update_grid(grid,user_choice,1)
#puts find_winner(grid,slices)
#print_grid(grid)
#update_grid(grid,grid.each_index.select{|x| grid[x].nil?}.sample,0)
#puts find_winner(grid,slices)
#print_grid(grid)
#user_choice = get_user_choice(grid)
#puts user_choice
#update_grid(grid,user_choice,1)
#puts find_winner(grid,slices)
#print_grid(grid)
#update_grid(grid,grid.each_index.select{|x| grid[x].nil?}.sample,0)
#puts find_winner(grid,slices)
#print_grid(grid)
#