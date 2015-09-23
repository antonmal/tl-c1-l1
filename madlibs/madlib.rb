require 'pry'

# (amalkov)
# Madlib app for the Tealeaf C1-L1

# 1. Open files with word samples (nouns, verbs, etc) for reading.
#       And turn their contents into arrays.
# 3. Open the file with our story for reading/writing.
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
    pos_file = pos + "s.txt"
    pos_string = File.read(pos_file)
    pos_hash[pos] = pos_string.split("\n")
  end

  pos_hash
end

sample_words_hash = load_sample_words

system "clear"

begin

  story_text = File.read("story.txt")

  PARTS_OF_SPEECH.each do |pos|
    while story_text.include?("<#{pos}>")
      story_text.sub!("<#{pos}>", sample_words_hash[pos].sample)
    end
  end

  puts
  puts
  puts story_text
  puts
  puts "Do you want to read more stories like this? (y/n)"

end until gets.chomp.downcase != "y"










