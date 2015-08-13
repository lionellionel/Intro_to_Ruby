# madlibs game

# new_words returns an anonymous hash with shuffled words
def new_words
  {
  'verb' => %w{ run sit drive throw bask drill eat debug code blend dry corrupt cook
                 specify outlaw dance pry define blast negotiate puncture}.shuffle,
  'noun' => %w{egg winnebaego star demon tree pylon bottle grasshopper
               existence pressure computation whirlpool molecule identity}.shuffle,
  'adjective' => %w{purple crazy deep fishy large airy wide ecstatic taciturn
                     obtuse derelict immense spongey gross illicit generic}.shuffle,
  'pluralnoun' => %w{rubber quarks rabbits keyboards cacti bacon tests
                      headphones fish arrays worts desktops semicolons}.shuffle,
  }
end

templates = Dir.glob("*.madlib")

if templates.length == 0
  puts "It appears you have no madlib templates"
  puts "This script looks for filenames *.madlib in the current directory"
  puts "It will randomly substitute for the following macros:"
  macros = new_words.keys.map{|type| '_' + type.upcase + '_' }
  puts macros
  exit
end

loop do
  puts "Choose a madlib:"

  templates.each_with_index do |template,index|
    puts "#{index+1}: #{template.sub(/.madlib/,'')}"
  end

  choice = gets.chomp

  until (1..templates.length).include?(choice.to_i)
    puts "not a valid selection"
    choice = gets.chomp
  end

  template = File.open(templates[choice.to_i-1])
  madlib = template.read
  template.close

  words = new_words()

  words.keys.each do |type|
    regex = '_' + type.upcase + '_'
    while madlib.match(regex) 
      #If template exhausts available words, refresh
      words = new_words if words[type].length < 1
      madlib.sub!(regex,words[type].pop)
    end
    
  end

  79.times{print "="}
  puts
  puts madlib

  puts "\nAgain? (Y/N)"
  again = gets.chomp
  break unless again.match(/^[Yy]/)
end