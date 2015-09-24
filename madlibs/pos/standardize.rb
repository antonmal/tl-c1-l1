require 'pry'

old_file_name = "adjectives.txt"
new_file_name = old_file_name.sub(".", "_tmp.")
old_file_array = File.readlines("adjectives.txt")

new_file = File.new(new_file_name, "w+")
new_file_array = []

old_file_array.each do |line|
  new_file_array.push(line.chomp.downcase)
end

new_file_array.each do |line|
  new_file.puts line
end

new_file.close