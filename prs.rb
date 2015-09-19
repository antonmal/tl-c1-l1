# Ask user to choose P, R or S
# Make random choice for computer
# Compare choices and announce the winner: you, computer, or a tie
# Ask if the user wants to play again
# Optional: keep score (total wins/ties/losses)

require 'pry'

OPTIONS = { "p" => "paper", "r" => "rock", "s" => "scissors", "e" => "exit" }
RESULTS = { 1 => "User won", 0 => "It's a tie", -1 => "Computer won" }


def user_choice
  loop do 
    puts " ." * 20

    prompt = "Choose "
    prompt += OPTIONS.map { |k,v| "(#{v[0].upcase})#{v[1..-1]}" }.join(", ").reverse.sub(", ".reverse, " or ".reverse).reverse
    prompt += " > "
    print prompt

    choice = gets.chomp.downcase

    # If user entered full word instead of first letter,
    # replace the choice with the first letter only
    if OPTIONS.values.include?(choice)
      choice = OPTIONS.key(choice)
    end

    exit if choice == "e"

    # If choice is one of the valid options, return it.
    # Otherwise return nil.
    if OPTIONS.keys.include?(choice)
      return choice
    else
      puts "I do not understand. Please, choose one of these options:"
    end
  end
end


def computer_choice
  ["p", "r", "s"].sample
end


def user_won?(user_chose, computer_chose)

  return 0 if user_chose == computer_chose

  case user_chose
  when "p"
    return 1 if computer_chose == "r"
    return -1 if computer_chose == "s"
  when "r"
    return 1 if computer_chose == "s"
    return -1 if computer_chose == "p"
  when "s"
    return 1 if computer_chose == "p"
    return -1 if computer_chose == "r"
  end
end


log = []
totals = {}
stats = {}

loop do
  u = user_choice
  c = computer_choice
  r = user_won?(u, c)

  puts "User: #{OPTIONS[u]} <=> Computer: #{OPTIONS[c]}"
  puts "*** #{RESULTS[r].upcase}! ***"

  log += [{ user: u, computer: c, result: r }]

  if !totals.has_key?(r)
    totals[r] = 1
  else
    totals[r] += 1
  end

  totals.each { |k,v| stats[RESULTS[k]] = ( v.to_f / log.size * 100 ).round.to_s + "%" }

  puts stats

  # puts "Do you want to play again? (Y/N)"
  # exit if ["n", "no"].include?(gets.chomp.downcase)
end










