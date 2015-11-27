require 'pry'
require 'yaml'

def get_calc_str
  puts "> #{message(:prompt)}"
  puts
  gets.chomp
end

def calculate(str)
  puts; exit if str == message(:exit)

  str = str.delete(" ")

  return message('do_not_understand') unless str =~ /^(\d+)([+-\/:*%])(\d+)$/

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

def choose_language
  begin
    puts "Choose your language: (E)nglish or (R)ussian"
    language = gets.chomp.downcase
  end until %w(r ru rus russian e en eng english).include? language
  if %w(r ru rus russian).include? language
    'ru'
  else
    'en'
  end
end

def message(msg)
  MESSAGES[LANGUAGE][msg.to_s]
end

system('clear')
LANGUAGE = choose_language
MESSAGES = YAML::load_file('calc_messages.yml')

loop do
  calc_str = get_calc_str
  puts calculate(calc_str)
  puts
end
