require 'pry'
require 'colorize'

### Blackjack app for Tealeaf L1-C1
### (by Anton Malkov)

### General logic/rules of the game
#
# Blackjack is a card game where you calculate the sum of the values of your cards 
# and try to hit 21, aka "blackjack".
# Both the player and dealer are dealt two cards to start the game. 
# All face cards are worth whatever numerical value they show.
# Suit cards are worth 10. Aces can be worth either 11 or 1.
# Example: if you have a Jack and an Ace, then you have hit "blackjack", as it adds up to 21.

# After being dealt the initial 2 cards, the player goes first
# and can choose to either "hit" or "stay".
# Hitting means deal another card.
# If the player's cards sum up to be greater than 21, the player has "busted" and lost.
# If the sum is 21, then the player wins.
# If the sum is less than 21, then the player can choose to "hit" or "stay" again.
# If the player "hits", then repeat above,
# but if the player stays, then the player's total value is saved,
# and the turn moves to the dealer.

# By rule, the dealer must hit until she has at least 17. 
# If the dealer busts, then the player wins. 
# If the dealer, hits 21, then the dealer wins. 
# If, however, the dealer stays, then we compare the sums of the two hands 
# between the player and dealer; higher value wins.

# More advanced rules can be found here:
# http://www.pagat.com/banking/blackjack.html



def get_ranks
  ranks = {}
  (2..10).each { |num| ranks[num.to_s] = num.to_s }
  ranks.merge!({ "J" => "Jack", "Q" => "Queen", "K" => "King", "A" => "Ace" })
end

def get_rank_points
  rank_points = {}
  (2..10).each { |num| rank_points[num.to_s] = num }
  rank_points.merge!({ "J" => 10, "Q" => 10, "K" => 10, "A" => 11 })
end

def get_suits
  { "♠" => "spades", "♥" => "hearts", "♦" => "diamonds", "♣" => "clubs" }
end

def get_points(hand)
  # Calculate the sum of all card values, aces as 11s
  points = hand.map { |card| get_card_points(card) }.inject(:+)

  # If the sum is greater than 21 (busted), re-calculate one or more aces as 1s
  if points > 21
    aces = hand.count { |card| card[0..-2] == "A" }
    aces.times do
      points -= 10
      break if points <= 21
    end
  end
  points
end

def get_card_points(card)
  get_rank_points[card[0..-2]]
end

def show_cards(player_hand, dealer_hand, player_name, hide_dealer_cards = true)

  clear_shell
  puts
  
  puts "Dealer's cards:"
  cards_str = ("+———+ " * dealer_hand.size + "\n").yellow

  dealer_hand.each_with_index do |card, index|
    cards_str += "|".yellow
    if index != 0 && hide_dealer_cards
      card = "-X-"
      cards_str += "-X-".light_black
    else
      cards_str += "#{card[0..-2].white}"
      cards_str += ['♥', '♦'].include?(card[-1]) ? card[-1].red : card[-1].blue
    end
    cards_str += " " if card.length < 3
    cards_str += "| ".yellow
  end

  cards_str += "= #{get_points(dealer_hand)}".yellow if !hide_dealer_cards

  cards_str += "\n"
  cards_str += ("+———+ " * dealer_hand.size).yellow
  puts cards_str

  puts
  puts "#{player_name}'s cards:"
  cards_str = ("+———+ " * player_hand.size + "\n").cyan

  player_hand.each do |card|
    cards_str += "|".cyan
    cards_str += "#{card[0..-2].white}"
    cards_str += ['♥', '♦'].include?(card[-1]) ? card[-1].red : card[-1].blue
    cards_str += " " if card.length < 3
    cards_str += "| ".cyan
  end
  cards_str += "= #{get_points(player_hand)}\n".cyan

  cards_str += ("+———+ " * player_hand.size).cyan
  puts cards_str
end


def game_state_message(game_state, player_name)
  player = player_name.upcase
  case game_state
  when "player blackjack"
    "*** #{player} WON ***  You have blackjack!".green
  when "dealer blackjack"
    "*** #{player} LOST ***  Dealer has blackjack!".red
  when "player busted"
    "*** #{player} LOST ***  Busted!".red
  when "dealer busted"
    "*** #{player} WON ***  Dealer busted!".green
  when "player won"
    "*** #{player} WON ***  You have more points!".green
  when "dealer won"
    "*** #{player} LOST ***  Dealer has more points!".red
  when "tie blackjack"
    "*** IT'S A TIE ***  Both have blackjack!".yellow
  when "tie busted"
    "*** IT'S A TIE ***  Both busted!".yellow
  when "tie points"
    "*** IT'S A TIE ***  You have equal number of points!".yellow
  else
    ""
  end
end

def clear_shell
  system('clear') || system('cls')
end

def deal(deck, number = 1)
  dealt = []
  number.times do
    random_card_index = rand(deck.size)
    dealt.push(deck[random_card_index])
    deck.delete_at(random_card_index)
  end
  dealt
end

def build_deck
  new_deck = []
  6.times do
    get_ranks.keys.each do |rank|
      get_suits.keys.each { |suit| new_deck.push "#{rank}#{suit}" }
    end
  end
  new_deck
end

def hit(deck, hand)
  hand.push(deal(deck).first)
end

def evaluate_state(player_hand, dealer_hand, final_count = false)

  player = get_points(player_hand)
  dealer = get_points(dealer_hand)

  if player > 21
    dealer > 21 ? "tie busted" : "player busted"
  elsif dealer > 21
    player > 21 ? "tie busted" : "dealer busted"
  elsif player == 21
    dealer == 21 ? "tie blackjack" : "player blackjack"
  elsif dealer == 21
    player == 21 ? "tie blackjack" : "dealer blackjack"
  elsif final_count
    if player == dealer
      "tie points"
    else
      player > dealer ? "player won" : "dealer won"
    end
  else
    ""
  end
end


clear_shell
puts "=> What is your name?".white.bold
puts
player_name = gets.chomp
puts
puts "=> Hi, #{player_name}"
puts
puts "=> Let the game begin!".yellow.bold
sleep 1

# Main game loop
begin

  deck = build_deck
  game_state = ""

  # Deal first two cards to player and dealer
  player_hand = deal(deck, 2)
  dealer_hand = deal(deck, 2)

  loop do

    ## Player moves
    # (Sep 27, 11:30) Changed the game rule to allow the player 
    # to hit and possibly achieve a tie if the dealer has 21 right away.
    # Dealer does not have this option. If a player achieves 21, the dealer always stays.
    # I think these rules are more correct, bit not 100% sure.
    begin
      break if get_points(player_hand) >= 21

      clear_shell
      show_cards(player_hand, dealer_hand, player_name)
      puts
      puts "=> Do you want to (H)it or (S)tay?".white.bold

      begin
        player_move = gets.chomp.downcase
      end until ['h', 's'].include?(player_move)

      hit(deck, player_hand) if player_move == 'h'
    end until player_move != 'h'

    game_state = evaluate_state(player_hand, dealer_hand)

    # Dealer moves
    while get_points(dealer_hand) < 17 && game_state == ""
      clear_shell
      show_cards(player_hand, dealer_hand, player_name, false)
      puts
      puts "=> Dealer is thinking ...".white.bold
      sleep 1.5
      hit(deck, dealer_hand)
    end

    # End game
    game_state = evaluate_state(player_hand, dealer_hand, true)
    break

  end

  clear_shell
  show_cards(player_hand, dealer_hand, player_name, false)
  puts
  puts "=> Game over:".white.bold
  puts game_state_message(game_state, player_name).bold
  puts
  puts "=> Do you want to play again? (y/n)".white.bold
  again = gets.chomp.downcase

end until again != "y"




