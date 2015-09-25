require 'pry'

# (amalkov)
# Madlib app for the Tealeaf C1-L1

# 1. Open files with word samples (nouns, verbs, etc) for reading.
#       And turn their contents into arrays.
# 3. Open the file with our story for reading/writing.
#      Get the file name from shell parameters.
# 4. Replace the markers in that file ('NOUN', 'VERB', etc).
#       with a random word of corresponding type.
# 5. Print out the filled-in story.
# 6. Ask if the player wants to read another generated story.


# Markers for parts of speach that will be replaced in the story file.
PARTS_OF_SPEECH = [
  "noun",
  "verb",
  "adjective",
  "adverb"
]

def load_sample_words
  pos_hash = {}

  PARTS_OF_SPEECH.each do |pos|
    pos_file = "pos/" + pos + "s.txt"
    pos_string = File.read(pos_file)
    pos_hash[pos] = pos_string.split("\n")
  end

  pos_hash
end

def say(msg)
  puts "=> #{msg}"
end

def exit_with(msg)
  say(msg)
  exit
end

exit_with("No file entered!") if ARGV.empty?
exit_with("File does not exist!") if !File.exist?(ARGV[0]) && !File.exist?("stories/" + ARGV[0])

sample_words_hash = load_sample_words

system "clear"

begin

  story_text = File.exist?(ARGV[0]) ? File.read(ARGV[0]) : File.read("stories/" + ARGV[0])

  ### Initial 'brute force' option
  #
  # PARTS_OF_SPEECH.each do |pos|
  #   search_for = "<#{pos}>"
  #   if pos == "verb"
  #     while story_text.include?(search_for + "ed")
  #       new_word = sample_words_hash[pos].sample
  #       if new_word[-1] == "e"
  #         new_word = new_word[0..-2]
  #       end
  #       story_text.sub!(search_for + "ed", new_word + "ed")
  #     end
  #     while story_text.include?(search_for + "ing")
  #       new_word = sample_words_hash[pos].sample
  #       if new_word[-1] == "e"
  #         new_word = new_word[0..-2]
  #       end
  #       story_text.sub!(search_for + "ing", new_word + "ing")
  #     end
  #   end 
  #   while story_text.include?(search_for)
  #     new_word = sample_words_hash[pos].sample
  #     story_text.sub!(search_for, new_word)
  #   end
  # end

  ### More consize and readable option after watching the video
  #
  PARTS_OF_SPEECH.each do |pos|
    if pos == "verb"
      story_text.gsub!("<verb>ed").each do
        sample_word = sample_words_hash[pos].sample
        sample_word[-1] == "e" ? sample_word[0..-2] + "ed" : sample_word + "ed"
      end
      story_text.gsub!("<verb>ing").each do
        sample_word = sample_words_hash[pos].sample
        sample_word[-1] == "e" ? sample_word[0..-2] + "ing" : sample_word + "ing"
      end
    end
    story_text.gsub!("<#{pos}>").each { sample_words_hash[pos].sample }
  end

  puts
  puts
  puts story_text
  puts
  puts "Do you want to read more stories like this? (y/n)"

end until $stdin.gets.chomp.downcase != "y"










