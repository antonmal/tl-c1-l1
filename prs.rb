# Ask user to choose P, R or S
# Make random choice for computer
# Compare choices and announce the winner: you, computer, or a tie
# Ask if the user wants to play again
# Optional: keep score (total wins/ties/losses)

require 'pry'

OPTIONS = { "p" => "paper", "r" => "rock", "s" => "scissors" }
RESULTS = { 1 => "User won", 0 => "It's a tie", -1 => "Computer won" }


def user_choice
  loop do
    puts
    puts " ." * 20
    puts

    prompt = "Choose "
    prompt += OPTIONS.map { |k,v| "(#{v[0].upcase})#{v[1..-1]}" }.join(", ")
    prompt += " or (E)xit > "
    print prompt

    choice = gets.chomp.downcase

    # If user entered full word instead of first letter,
    # replace the choice with the first letter only
    if OPTIONS.values.include?(choice)
      choice = OPTIONS.key(choice)
    end

    # If choice is one of the valid options, including "e" (exit), return it.
    # Otherwise ask to ghoose once again.
    if OPTIONS.keys.push("e").include?(choice)
      return choice
    else
      puts "I do not understand. Please, choose one of these options:"
    end
  end
end


def computer_choice
  OPTIONS.keys.sample
end


def user_won?(usr, cmp)
  turn = usr + cmp

  case turn
  when "pp", "rr", "ss"
    return 0
  when "pr", "rs", "sp"
    return 1
  when "ps", "rp", "sr"
    return -1
  end
end


log = []
totals = {}
stats = {}

puts 
puts "Welcome to the PRS (Paper Rock Scissors) game!"

loop do
  usr = user_choice
  # Print out the log and exit the program to shell if the user inputs "e"
  if usr == "e"
    puts
    puts "Here is the log of your game:"
    puts log
    puts
    puts "See you soon! :)"
    puts
    exit
  end

  cmp = computer_choice
  res = user_won?(usr, cmp)

  puts "User: #{OPTIONS[usr]} <=> Computer: #{OPTIONS[cmp]}"
  puts "*** #{RESULTS[res].upcase}! ***"

  log += [{ user: usr, computer: cmp, result: res }]

  if !totals.has_key?(res)
    totals[res] = 1
  else
    totals[res] += 1
  end

  totals.each { |k,v| stats[RESULTS[k]] = ( v.to_f / log.size * 100 ).round.to_s + "%" }

  puts stats

end










