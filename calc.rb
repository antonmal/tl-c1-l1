def get_calc_str(prompt)
  puts
  puts prompt
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
  first = m["first"].to_i
  second = m["second"].to_i
  operator = m["operator"]

  case operator
  when "+"
    first + second
  when "-"
    first - second
  when "*"
    first * second
  when "/"
    first / second
  when "%"
    first % second
  else
    nil
  end
end

while true
  puts calculate( get_calc_str "What do you want to calculate? (Enter 'exit' to stop.)" )
end



