require 'pry'
require 'yaml'

def calc_str
  puts "> #{message(:prompt)}"
  puts
  gets.chomp
end

def parse_and_calculate(str)
  puts; exit if str == message(:exit)

  str = str.delete(' ')

  return message('do_not_understand') unless str =~ /^\d+[+-\/:*%]\d+$/

  # Calculate using the built-in eval method
  # return eval(str)

  # Calculate using my own regex-based method
  first, operator, second = /(^(\d+)([+-\/:*%])(\d+)$)/.match(str).captures

  '= ' + calculate(first, operator, second).to_s
end

def calculate(first, operator, second)
  case operator
  when '+'      then first.to_i + second.to_i
  when '-'      then first.to_i - second.to_i
  when '*'      then first.to_i * second.to_i
  when '/', ':' then first.to_f / second.to_i
  when '%'      then first.to_i % second.to_i
  end
end

def choose_language
  loop do
    puts 'Choose your language: (E)nglish or (R)ussian'
    language = gets.chomp.downcase
    break if %w(r ru rus russian e en eng english).include? language
  end
  return 'ru' if %w(r ru rus russian).include? language
  'en'
end

def message(msg)
  MESSAGES[LANGUAGE][msg.to_s]
end

system('clear')
LANGUAGE = choose_language
MESSAGES = YAML.load_file('calc_messages.yml')

loop do
  puts parse_and_calculate(calc_str)
  puts
end
