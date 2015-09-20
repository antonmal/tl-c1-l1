require 'pry'

COLUMNS = 3
ROWS = 3
ROW_LABELS = ('A'..'Z').first(ROWS)

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


def check_full(moves_hash)

  if moves_hash.size >= ROWS * COLUMNS
    system('clear')
    draw_field(moves_hash)

    puts
    puts "*** Game over ***"
    puts "  The board is full"
    puts
    puts "Thanks for playing! See you next time!"
    puts

    exit
  end

end


def get_player_move(moves_hash)

  check_full(moves_hash)

  puts
  puts "### Where do you want to make your move? ###"
  puts "  (Enter the row label followed by the column number like this: 'A1')"
  puts "  Or enter 'E' to exit."
  puts ">>>"

  loop do
    move = gets.chomp.upcase.delete(" ")
    exit if move == "E" || move == "EXIT"

    if /^\w\d$/.match(move).nil?
      system('clear')
      draw_field(moves_hash)
      puts
      puts "*** I do not understand. ***"
      puts "  Enter the cell where you want to move in the following format: 'A1',"
      puts "  where 'A' is the row label and '1' is the column number."
      puts ">>>"

    elsif !ROW_LABELS.include?(move[0])
      system('clear')
      draw_field(moves_hash)
      puts
      puts "*** Wrong row label. ***"
      puts "  Should be between #{ROW_LABELS[0]} and #{ROW_LABELS[-1]}"
      puts "Try again."
      puts ">>>"

    elsif !(1..COLUMNS).include?(move[1].to_i)
      system('clear')
      draw_field(moves_hash)
      puts
      puts "*** Wrong column number. ***"
      puts "  Should be between 1 and #{COLUMNS}"
      puts "Try again."
      puts ">>>"

    elsif moves_hash.has_key?(move)
      system('clear')
      draw_field(moves_hash)
      puts
      if moves_hash[move] == "X"
        puts "*** You already made a move here. ***"
      else
        puts "*** Comuter has already moved here. ***"
      end
      puts "Choose an empty cell."
      puts ">>>"

    else
      moves_hash[move] = 'X'
      break
    end
  end

end


def get_computer_move(moves_hash)

  check_full(moves_hash)

  loop do
    move = ROW_LABELS.sample + (1..COLUMNS).to_a.sample.to_s
    if !moves_hash.has_key?(move)
      moves_hash[move] = 'O'
      break
    end
  end

end


moves_hash = {}

loop do

  system('clear')
  draw_field(moves_hash)

  get_player_move(moves_hash)

  get_computer_move(moves_hash)

end








