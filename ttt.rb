
# (amalkov)
# TicTacToe game for the Tealeaf C1-L1 assignment

# 1. To practice more complicated logic, created it with flexible board size.
# 2. Added labels to the board (letters for rows, numbers for columns).
# 3. Players enters chess-style references to board cells.
#       This is more universal for different board sizes.
# 4. Second human oponent option.
# 5. For computer opponent - first simple random logic.
#     Then added minimax algorithm.
# 5. Used colorize library to style text messages in the shell.


require 'pry'
require 'colorize'

COLUMNS = 3
ROWS = 3
ROW_LABELS = ('A'..'Z').first(ROWS)
MARKERS = { "Player 1" => "X", "Player 2" => "O" }

def draw_board(moves_hash)

  column_width = 9  # Width of each cell in characters excluding borders
  row_height = 3    # Height of each cell in characters excluding borders
  label_width = 2   # Width of the first column in which row labels are displayed
  label_height = 1  # Height of the first row where the column lables are displayed

  board = {}

  # Add column labels (numbers 1..n)
  board[0] = " " * label_width + ("|" + " "*column_width) * COLUMNS + "|"
  for col in 1..COLUMNS do
    board[0][label_width + col*(column_width + 1) - (column_width/2 + 1)] = col.to_s
  end

  # Draw empty board
  for row in 0..ROWS do
    # Draw horizontal lines between cells
    board[label_height + row*(row_height + 1)] = "-" * label_width + ("+" + "-"*column_width) * COLUMNS + "+"

    # Draw empty cells
    for row_line in 1..row_height do
      board[label_height + row*(row_height + 1) + row_line] = " " * label_width + ("|" + " "*column_width) * COLUMNS + "|"
      
      # If in the middle of the row, add row label (letters A, B, ...)
      if row_line == row_height / 2 + 1
        board[label_height + row*(row_height + 1) + row_line][0] = ROW_LABELS[row]
      end
    end unless row == ROWS # Do not draw emty cells below the bottom line
  end

  # Show previously made moves on the drawn board
  moves_hash.each do |cell, marker|
    marker_row = ROW_LABELS.index(cell[0]) + 1
    marker_column = cell[1].to_i
    marker_row_center = label_height + marker_row*(row_height + 1) - (row_height/2 + 1)
    marker_column_center = label_width + marker_column*(column_width + 1) - (column_width/2 + 1)

    board[marker_row_center][marker_column_center] = marker
  end

  board.each { |key, row_line| puts row_line }

end


def get_player_move(moves_hash, player)

  system('clear')
  draw_board(moves_hash)

  puts
  if MARKERS[player] == 'X'
    puts "___ Hey, #{player}! ___".green
  else
    puts "___ Hey, #{player}! ___".red
  end

  puts "### Where do you want to make your move? ###"
  puts "  (Enter the row label followed by the column number like this: 'A1')"
  puts "  Or enter 'E' to exit."
  puts "VVV"

  loop do
    move = gets.chomp.upcase.delete(" ")
    exit if move == "E" || move == "EXIT"

    if /^\w\d$/.match(move).nil?
      system('clear')
      draw_board(moves_hash)
      puts
      puts "*** I do not understand. ***".yellow
      puts "  Enter the cell where you want to move in the following format: 'A1',"
      puts "  where 'A' is the row label and '1' is the column number."
      puts "VVV"

    elsif !ROW_LABELS.include?(move[0])
      system('clear')
      draw_board(moves_hash)
      puts
      puts "*** Wrong row label. ***".yellow
      puts "  Should be between #{ROW_LABELS[0]} and #{ROW_LABELS[-1]}"
      puts "Try again."
      puts "VVV"

    elsif !(1..COLUMNS).include?(move[1].to_i)
      system('clear')
      draw_board(moves_hash)
      puts
      puts "*** Wrong column number. ***".yellow
      puts "  Should be between 1 and #{COLUMNS}"
      puts "Try again."
      puts "VVV"

    elsif moves_hash[move] != " "
      system('clear')
      draw_board(moves_hash)
      puts
      puts "*** This cell is already occupied. ***".yellow
      puts
      puts "Choose an empty cell."
      puts
      puts "VVV"

    else
      moves_hash[move] = MARKERS[player]
      break
    end
  end

end


def game_over?(moves_hash)

  # Check if someone won
  won = check_3_in_a_row(moves_hash)

  if !won.nil?
    system('clear')
    draw_board(moves_hash)

    puts
    puts "*** Game over ***".yellow
    puts
    puts "#{MARKERS.key(won)} is the winner !!!"
    puts
    puts "Thanks for playing! See you next time!"
    puts

    exit
  end

  # Check if board is full (thus there is a tie)
  if board_full(moves_hash)
    system('clear')
    draw_board(moves_hash)

    puts
    puts "*** Game over ***".yellow
    puts
    puts "  It's a TIE!!!"
    puts
    puts "Thanks for playing! See you next time!"
    puts

    exit
  end

end


def board_full(moves_hash)
  moves_hash.values.count(" ") == 0
end


def get_board_array(moves_hash)
  ba = Array.new(ROWS) { Array.new(COLUMNS, " ") }
  moves_hash.each do |cell, marker|
    ba[ ROW_LABELS.index(cell[0]) ][ cell[1].to_i - 1 ] = marker
  end
  ba
end


def check_3_in_a_row(moves_hash)

  board_array = get_board_array(moves_hash)
  
  # Check in horizontal lines
  (0..(ROWS-1)).each do |row|
    MARKERS.each do |player, marker|
      if board_array[row].join.include?( marker*3 )
        return marker
      end
    end

  end

  # Check in vertical lines
  (0..(COLUMNS-1)).each do |column|
    column_string = ""
    (0..(ROWS-1)).each do |row|
      column_string += board_array[row][column]
    end
    MARKERS.each do |player, marker|
      if column_string.include?( marker*3 )
        return marker
      end
    end
  end

  # Check in diagonal lines
  # For now - only the main diagonals (not suitable for board sizes > 3)
  diagonal_top_bottom = ""
  diagonal_bottom_top = ""

  (0..(COLUMNS-1)).each do |column|
      diagonal_top_bottom += board_array[column][column]
      diagonal_bottom_top += board_array[board_array.size - 1 - column][column]
  end

  MARKERS.each do |player, marker|
    if diagonal_top_bottom.include?( marker*3 )
      return marker
    end
    if diagonal_bottom_top.include?( marker*3 )
      return marker
    end
  end

  nil

end


def get_computer_move(moves_hash)

  system 'clear'
  draw_board(moves_hash)
  puts
  puts "Computer is thinking..."
  sleep 1

  # Simple random empty cell logic
  # move = get_available_moves(moves_hash).sample
  # moves_hash[move] = MARKERS['Player 2']

  # More complex AI logic (Minimax algorythm)
  move_weights = {} # a hash of weights for each available move

  # Populate the weights hash, recursing as needed
  get_available_moves(moves_hash).each do |move|

    new_board_state = {}
    new_board_state.merge!(moves_hash).update( { move => MARKERS['Player 2'] } )

    move_weights.merge!({ move => minimax(new_board_state) })

  end

  binding.pry

  best_weight = move_weights.values.max
  best_move = move_weights.key(best_weight)

  moves_hash[best_move] = MARKERS['Player 2'] 
end


def get_available_moves(moves_hash)
  moves_hash.select { |cell, marker| marker == " " }.keys
end


def computer_move_weight(moves_hash)
    # If computer wins
    if check_3_in_a_row(moves_hash) == MARKERS['Player 2']
        return 1
    elsif check_3_in_a_row(moves_hash) == MARKERS['Player 1']
        return -1
    else
        return 0
    end
end


def minimax(board_state, marker = MARKERS['Player 2'] )

  # If game is over because someone won or because the board is full
  #   then stop weighing subsecuent moves and return the weight of the last move
  return computer_move_weight(board_state) if check_3_in_a_row(board_state) || board_full(board_state)

  # Cycle markers for each subsecuent move
  next_move_marker = MARKERS.select {|p, m| m != marker }.values[0]
  weigh_moves = {} # a hash of weights for each available move

  # Populate the weights array, recursing as needed
  get_available_moves(board_state).each do |next_move|

      new_board_state = {}
      new_board_state.merge!(board_state).update( { next_move => next_move_marker } )
      next_move_weight = minimax(new_board_state, next_move_marker)

      weigh_moves.merge!({ next_move => next_move_weight })
  end

  # Do the min or the max calculation
  if next_move_marker == MARKERS['Player 2'] # It's computer's turn
      return weigh_moves.values.max
  else
      return weigh_moves.values.min
  end

end


def init_moves_hash
  mh = {}
  (1..COLUMNS).each do |column|
    (0..(ROWS-1)).each do |row|
      mh[ROW_LABELS[row]+column.to_s] = " "
    end
  end
  mh

  # Pre-filled board to test computer AI
  # {
  #   "A1" => "X", "A2" => "O", "A3" => " ",
  #   "B1" => "X", "B2" => "O", "B3" => " ",
  #   "C1" => "O", "C2" => "X", "C3" => " ",
  # }
end 


# The main game loop

moves_hash = init_moves_hash

loop do

  get_player_move(moves_hash, 'Player 1')
  game_over?(moves_hash)

  # get_player_move(moves_hash, 'Player 2')
  # game_over?(moves_hash)

  get_computer_move(moves_hash)
  game_over?(moves_hash)

end








