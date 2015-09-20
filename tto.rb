require 'pry'
require 'colorize'

COLUMNS = 3
ROWS = 3
ROW_LABELS = ('A'..'Z').first(ROWS)
MARKERS = { 'Player 1' => 'X', 'Player 2' => 'O' }

def draw_field(moves_hash)

  column_width = 9
  row_height = 3
  columns_number = COLUMNS
  rows_number = ROWS
  label_width = 2
  label_height = 1
  row_letters = ROW_LABELS
  field = {}

  # Add column labels (numbers 1..n)
  field[0] = " " * label_width + ("|" + " "*column_width) * columns_number + "|"
  for col in 1..columns_number do
    field[0][label_width + col*(column_width + 1) - (column_width/2 + 1)] = col.to_s
  end

  # Draw empty field
  for row in 0..rows_number do
    # Draw horizontal lines between cells
    field[label_height + row*(row_height + 1)] = "-" * label_width + ("+" + "-"*column_width) * columns_number + "+"

    # Draw empty cells
    for row_line in 1..row_height do
      field[label_height + row*(row_height + 1) + row_line] = " " * label_width + ("|" + " "*column_width) * columns_number + "|"
      
      # If in the middle of the row, add row label (letters A, B, ...)
      if row_line == row_height / 2 + 1
        field[label_height + row*(row_height + 1) + row_line][0] = row_letters[row]
      end
    end unless row == rows_number # Do not draw emty cells below the bottom line
  end

  # Show previously made moves on the drawn field
  moves_hash.each do |cell, marker|
    marker_row = row_letters.index(cell[0]) + 1
    marker_column = cell[1].to_i
    marker_row_center = label_height + marker_row*(row_height + 1) - (row_height/2 + 1)
    marker_column_center = label_width + marker_column*(column_width + 1) - (column_width/2 + 1)

    field[marker_row_center][marker_column_center] = marker
  end

  field.each { |key, row_line| puts row_line }

end


def get_player_move(moves_hash, player)

  system('clear')
  draw_field(moves_hash)

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
      draw_field(moves_hash)
      puts
      puts "*** I do not understand. ***".yellow
      puts "  Enter the cell where you want to move in the following format: 'A1',"
      puts "  where 'A' is the row label and '1' is the column number."
      puts "VVV"

    elsif !ROW_LABELS.include?(move[0])
      system('clear')
      draw_field(moves_hash)
      puts
      puts "*** Wrong row label. ***".yellow
      puts "  Should be between #{ROW_LABELS[0]} and #{ROW_LABELS[-1]}"
      puts "Try again."
      puts "VVV"

    elsif !(1..COLUMNS).include?(move[1].to_i)
      system('clear')
      draw_field(moves_hash)
      puts
      puts "*** Wrong column number. ***".yellow
      puts "  Should be between 1 and #{COLUMNS}"
      puts "Try again."
      puts "VVV"

    elsif moves_hash.has_key?(move)
      system('clear')
      draw_field(moves_hash)
      puts
      if moves_hash[move] == "X"
        puts "*** You already made a move here. ***".yellow
      else
        puts "*** Comuter has already moved here. ***".yellow
      end
      puts "Choose an empty cell."
      puts
      puts "VVV"

    else
      moves_hash[move] = MARKERS[player]
      break
    end
  end

  check_if_over(moves_hash)

end


def check_if_over(moves_hash)

  # Check if someone won
  won = check_3_in_a_row(moves_hash)

  if !won.nil?
    system('clear')
    draw_field(moves_hash)

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
  if moves_hash.size >= ROWS * COLUMNS
    system('clear')
    draw_field(moves_hash)

    puts
    puts "*** Game over ***".yellow
    puts
    puts "  The board is full"
    puts
    puts "Thanks for playing! See you next time!"
    puts

    exit
  end

end


def check_3_in_a_row(moves_hash)

  board_array = Array.new(3) { Array.new(3, " ") }
  moves_hash.each do |cell, marker|
    board_array[ ROW_LABELS.index(cell[0]) ][ cell[1].to_i - 1 ] = marker
  end
  
  # Check in horizontal lines
  for row in 0..(ROWS-1) do
    MARKERS.each do |player, marker|
      if board_array[row].join.include?( marker*3 )
        return marker
      end
    end
  end

  # Check in vertical lines
  for column in 0..(COLUMNS-1) do
    column_string = ""
    for row in 0..(ROWS-1) do
      column_string += board_array[row][column]
    end
    MARKERS.each do |player, marker|
      if column_string.include?( marker*3 )
        return marker
      end
    end
  end

  # Check in diagonal lines
  # For now - only the main diagonals
  diagonal_top_bottom = ""
  diagonal_bottom_top = ""

  for column in 0..(COLUMNS-1) do
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

  check_full(moves_hash)

  loop do
    move = ROW_LABELS.sample + (1..COLUMNS).to_a.sample.to_s
    if !moves_hash.has_key?(move)
      moves_hash[move] = MARKERS['Player 2']
      break
    end
  end

end


moves_hash = {}

loop do

  get_player_move(moves_hash, 'Player 1')

  get_player_move(moves_hash, 'Player 2')

  #get_computer_move(moves_hash)

end








