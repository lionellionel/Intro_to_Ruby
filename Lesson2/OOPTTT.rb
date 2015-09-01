#OOP TTT

#Grid represents the TTT playing board
class Grid
	attr_accessor :coordinates

	# a slice is a set of grid coordinates that
	# represents a line going through 3 squares in the grid
  SLICES = [
 		[0,1,2],[3,4,5],[6,7,8],
 		[0,3,6],[1,4,7],[2,5,8],
 		[0,4,8],[2,4,6]
  ]
  #in @coordinates, nil is an open space, 0 is pip for player1,
  #    1 is a pip for player2
	def initialize
		@coordinates = Array.new(9)
	end

	def update(coordinate, value)
		@coordinates[coordinate]=value
	end

	def suggest(position)
		opponents_position = position == 0 ? 1 : 0
		# look for wins for player, then blocks on opponent 
		[ position, opponents_position ].each do |win_or_block|
		 	open_spaces.each do |coordinate|
		 		# Marshal dump/load seems the easiest way to do a 
		 		# "deep copy" of self
		 		temp_grid = Marshal.load(Marshal.dump(self))
	
				# Update temp grid for analysis
		 		temp_grid.update(coordinate, win_or_block)

		 		return coordinate if temp_grid.winner?

	  	end
    end
	
  	# else pick from this order: center, corners, edges
  	# Note: not a perfect algorithm - computer can be beat!
  	[4,0,2,6,8,1,3,5,7].each do |coordinate|
      return coordinate if open_spaces.include?(coordinate)
    end
    nil
	end

	def show
	  # map grid to pip character for display purposes
	  grid_display = 
	    coordinates.map do |pip|
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

	def is_full?
		!@coordinates.include?(nil)
	end

	def winner?
		SLICES.each do |slice| 
    	pips_in_slice = slice.map{|coordinate| @coordinates[coordinate]}
    	#if slice has empty space, it can't be a winner
    	next if pips_in_slice.include?(nil)
    	# if all equal, return winner
    	return pips_in_slice[0] if pips_in_slice.uniq.length == 1
  	end
  	nil
	end

	def open_spaces
		@coordinates.each_index.select{|coordinate| @coordinates[coordinate].nil?}
	end

end    

class Player
	# :position = 0 means that Player goes first, and their moves are represented
	#  by a 0 in Grid.coordinates.   likewise :position = 1 means player goes 2nd
	attr_accessor :name, :is_human, :position

	def initialize(name, is_human, position)
		name = 'Computer' if name.empty?
		@name = name
  	@is_human = is_human
  	@position = position
	end

	def go(grid)
		if @is_human
			puts "#{name}, it's your turn"
			puts 'Enter coordinate 1-9'
  		choice = gets.chomp.to_i - 1
  		until grid.open_spaces.include?(choice)
    		puts "Invalid choice.  Choose an available space"
    		choice = gets.chomp.to_i - 1
  		end
  	else
  		puts 'Computer is deciding ...'
  		sleep 3
  		choice = grid.suggest(@position)
  	end	
  	grid.update(choice,@position)
  end	
end

class TicTacToe
	attr_accessor :score, :player1, :player2

	def initialize
	  system 'clear'
		puts 'Player 1 will go first.  Please enter name, or hit ENTER to assign computer as Player1'
		player1_name = gets.chomp
		puts 'Please enter Player 2 name, or hit ENTER to assign computer as Player 2'
		player2_name = gets.chomp
		@player1 = Player.new(player1_name, !player1_name.empty?, 0)
		@player2 = Player.new(player2_name, !player2_name.empty?, 1)
		@score = [0,0,0] # player1 win count, player2 win count, cats eyes count
	end

	def play
		@grid = Grid.new
		loop do
			@grid.show
			@player1.go(@grid)
			@grid.show
			break if @grid.winner? || @grid.is_full?
			@player2.go(@grid)
			@grid.show
			break if @grid.winner? || @grid.is_full?
		end
		if @grid.winner? == 0
			puts "#{@player1.name} won!"
			@score[0] += 1
		elsif @grid.winner? == 1
			puts "#{@player2.name} won!"
			@score[1] += 1
		else
			puts 'Cats Eye!'
			@score[2] += 1
		end
	end

end

game = TicTacToe.new
loop do
	game.play
	puts 'The score thus far:'
	puts "#{game.player1.name}: #{game.score[0]}"
	puts "#{game.player2.name}: #{game.score[1]}"
	puts "Cat's Eyes: #{game.score[2]}"
  puts 'Play again? (Y/N)'
  break unless gets.chomp =~ /^[Yy]/
end