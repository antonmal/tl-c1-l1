require 'pry'

def get_calc_str(prompt)
  puts " . . . "
  puts "> #{prompt}"
  gets.chomp
end

def calculate(str)
  exit if str == "exit"

  str = str.delete(" ")
  
  return "I do not understand. Try something simpler like '1+1'." unless str =~ /^(\d+)([+-\/:*%])(\d+)$/
  
  # Calculate using the built-in eval method
  # return eval(str)

  # Calculate using my own regex-based method
  m = /^(?<first>\d+)(?<operator>[+-\/:*%])(?<second>\d+)$/.match(str)

  res = case m["operator"]
        when "+"
          m["first"].to_i + m["second"].to_i
        when "-"
          m["first"].to_i - m["second"].to_i
        when "*"
          m["first"].to_i * m["second"].to_i
        when "/", ":"
          m["first"].to_f / m["second"].to_i
        when "%"
          m["first"].to_i % m["second"].to_i
        else
          nil
        end

  "= " + res.to_s
end

calc_prompt = "What do you want to calculate? (Enter 'exit' to stop.)"
system('clear')

loop do
  puts calculate(get_calc_str(calc_prompt))
  sleep 2
  system('clear')
end



