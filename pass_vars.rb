## Variable scope

# def try_passing_vars(a)
#   puts a
#   b = 2
# end

# 1.times do
#   a = 10
# end

# try_passing_vars(a)

# puts b


## Destructive / non-destructive methods

# def add_name(arr, name)
#   arr += [name]
# end

# names = ['bob', 'kim']
# add_name(names, 'jim')
# puts names.inspect


## Variables as pointers
# def test(b)
#   b.map! {|letter| "I like the letter: #{letter}"}
# end

# a = ['a', 'b', 'c']
# puts test(a)
# puts
# puts a


## Another example of vars as pointers
# a = [1, 2, 3, 3]
# b = a
# c = a.uniq!

# p a
# puts
# p b
# puts
# p c


## Exercise for var passing
# a = 'hi there'
# b = a
# a.gsub!(' ', '_') # both a and b are affected by the destructive method gsub!

# puts "a: #{a}"
# puts "b: #{b}"


## Exercise 2
# a = 'hi there'
# b = a
# a = [1, 2, 3] # only a gets reassigned by '='

# puts "a: #{a}"
# puts "b: #{b}"






