require 'pry'
require 'yaml'

def calc_str
  puts "> #{message(:prompt)}"
  puts
  gets.chomp
end

def calc_result(str)
  exit if str == message(:exit)

  str = str.delete(' ')

  return message('do_not_understand') unless str =~ %r{^\d+[+-\/:*%]\d+$}

  # Calculate using the built-in eval method
  # return eval(str)

  # Calculate using my own regex-based method
  first, operator, second = %r{(^(\d+)([+-/:*%])(\d+)$)}.match(str).captures

  '= ' + calculate(first, operator, second).to_s
end

# rubocop:disable Metrics/AbcSize
def calculate(first, operator, second)
  case operator
  when '+'      then first.to_i + second.to_i
  when '-'      then first.to_i - second.to_i
  when '*'      then first.to_i * second.to_i
  when '/', ':' then first.to_f / second.to_i
  when '%'      then first.to_i % second.to_i
  end
end
# rubocop:enable Metrics/AbcSize

def choose_language
  puts 'Choose your language: (E)nglish or (R)ussian'
  lang = gets.chomp.downcase
  until %w(r ru rus russian e en eng english).include? lang
    puts 'I do not understand.'
    puts 'Choose one of the following options: (E)nglish or (R)ussian'
    lang = gets.chomp.downcase
  end
  return 'ru' if %w(r ru rus russian).include? lang
  'en'
end

def message(msg)
  MESSAGES[LANGUAGE][msg.to_s]
end

system('clear')
LANGUAGE = choose_language
MESSAGES = YAML.load_file('calc_messages.yml')

loop do
  puts calc_result(calc_str)
  puts
end
