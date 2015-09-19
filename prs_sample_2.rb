def compete(user,comp)

  if user == "P" && comp == "P"
    puts "You picked paper and computer picked paper"
    puts "It's a tie!"
  elsif user == "P" && comp == "R"
    puts "You picked paper and computer picked rock"
    puts "You win!"
  elsif user == "P" && comp == "S"
    puts "You picked paper and computer picked scissors"
    puts "You lose!"
  elsif user == "R" && comp == "P"
    puts "You picked rock and computer picked paper"
    puts "You lose!"
  elsif user == "R" && comp == "R"
    puts "You picked rock and computer picked rock"
    puts "It's a tie!"
  elsif user == "R" && comp == "S"
    puts "You picked rock and computer picked scissors"
    puts "You win!"
  elsif user == "S" && comp == "P"
    puts "You picked scissors and computer picked paper"
    puts "You win!"
  elsif user == "S" && comp == "R"
    puts "You picked scissors and computer picked rock"
    puts "You lose!"
  elsif user == "S" && comp == "S"
    puts "You picked scissors and computer picked scissors"
    puts "It's a tie"
  else
    puts "ERR: Wrong Input!"
    err_check
  end        
end

def err_check
  puts "Choose one: (P | R | S)"
  choice = gets.chomp
  choice = choice.upcase
  comp_choice = ["P", "R", "S"].sample
  compete(choice,comp_choice)
end


puts "
 _______ _______ _______ _______ _______   
(  ____ (  ___  (  ____ (  ____ (  ____ )  ( )
| (    )| (   ) | (    )| (    '| (    )|  | |
| (____)| (___) | (____)| (__   | (____)|  (_)
|  _____|  ___  |  _____|  __)  |     __)   _ 
| (     | (   ) | (     | (     | (| (     ( )
| )     | )   ( | )     | (____/| ) | [__  | |
|/      |/     [|/      (_______|/   |__/  (_)
                                              "
puts "-----------------------------------------------"
puts "
 _______ _______ _______ _          _ 
(  ____ (  ___  (  ____ | [    /]  ( )
| (    )| (   ) | (    [|  [  / /  | |
| (____)| |   | | |     |  (_/ /   (_)
|     __| |   | | |     |   _ (     _ 
| ([ (  | |   | | |     |  ( [ ]   ( )
| ) [ [_| (___) | (____/|  /  [ ]  | |
|/   [__(_______(_______|_/    []  (_)
                                      "
puts "-----------------------------------------------"
puts "
 _______ _______________________ _______ _______ _______ _______    _ 
(  ____ (  ____ [__   __(  ____ (  ____ (  ___  (  ____ (  ____ |  ( )
| (    [| (    [/  ) (  | (    [| (    [| (   ) | (    )| (    |/  | |
| (_____| |        | |  | (_____| (_____| |   | | (____)| (_____   (_)
(_____  | |        | |  (_____  (_____  | |   | |     __(_____  )   _ 
      ) | |        | |        ) |     ) | |   | | (| (        ) |  ( )
/|____) | (____/___) (__/[____) /[____) | (___) | ) | |_/|____) |  | |
[_______(_______[_______[_______[_______(_______|/   |__|_______)  (_)
                                                                      "
puts "-----------------------------------------------"


puts "Play Paper_Rock_Scissors!"

begin

  puts "Choose one: (P | R | S)"
  choice = gets.chomp
  choice = choice.upcase

  comp_choice = ["P", "R", "S"].sample

  compete(choice,comp_choice)

  puts "-------------------------"
  puts "play again? (Y/N)"
  answer = gets.chomp
  answer = answer.upcase
  puts "-------------------------"

end while answer == "Y"
