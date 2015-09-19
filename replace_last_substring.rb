def rsub(str, replace, by)
  str.reverse.sub(replace.reverse, by.reverse).reverse
end

puts rsub("foo bar foo bar foo", "foo", "xxx")