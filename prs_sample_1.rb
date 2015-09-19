def display_winning_message(winning_choice)
  case winning_choice
  when 'r'
    puts "You: Rock | Me: Scissors"
  when 'p'
    puts "You: Paper | Me: Rock"
  when 's'
    puts "You: Scissors | Me: Paper"
  end
end

def display_losing_message(losing_choice)
  case losing_choice
  when 'r'
    puts "You: Rock | Me: Paper"
  when 'p' 
    puts "You: Paper | Me: Scissors"
  when 's'
    puts "You: Scissors | Me: Rock"
  end
end

CHOICES = {'r' => 'Rock', 'p' => 'Paper', 's' => 'Scissors' }
puts "Let's play 'Rock, Paper, Scissors!'"

loop do
  # player chooses
  begin
    puts "Please choose [r] for Rock, [p] for Paper, or [s] for Scissors."
    user_choice = gets.chomp.downcase
  end until CHOICES.keys.include?(user_choice)

  # the computer chooses
  computer_choice = CHOICES.keys.sample

  # determine who won

  if user_choice == computer_choice
    puts "It's a tie!"
  elsif (user_choice == 'r' && computer_choice == 's') || (user_choice == 'p' && computer_choice == 'r') || (user_choice == 's' && computer_choice == 'p')
    display_winning_message(user_choice)
    puts "You win!"
  else
    display_losing_message(user_choice)
    puts "Sorry, you lose..."
  end

  puts "Would you like to play again? (y/n)"
  break if gets.chomp.downcase != 'y'

end

puts "Thanks for playing!"
