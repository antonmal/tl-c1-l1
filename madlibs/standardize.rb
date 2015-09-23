File.open("adv.txt", "w+") do |destination|
  File.readlines("adverbs.txt", "r").each do |line|
    line.split(" ").each do |word|
      destination << word + "\n"
    end
  end
end

