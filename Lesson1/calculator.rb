# A basic cli based calculator
#  performs computation on two integers

def get_num
  puts "Enter an integer: "
  num = gets.chomp
  until num =~ /^\d+$/
    puts "Nope.  Please enter a valid integer"
    num = gets.chomp
  end
  num
end

def get_operand
  puts "Enter an operand"
  puts "1. +\n2. -\n3. *\n4. /\n"
  operand = gets.chomp.to_i
  until (1..4).include?(operand)
    puts "Nope.  Please enter integer between 1-4"
    operand = gets.chomp.to_i
  end
  operand
end


loop do
  num1 = get_num
  operand = get_operand
  num2 = get_num

  if operand == 4 && num2.to_i == 0
    puts "Explosion to Infinity, try again"
    next
  end

  answer =
    case operand
    when 1 then num1.to_i + num2.to_i
    when 2 then num1.to_i - num2.to_i
    when 3 then num1.to_i * num2.to_i
    when 4 then num1.to_f / num2.to_f
    end

  puts "The answer is: #{answer}\n\n"
  puts "Want another?"
  yes_or_no = gets.chomp
  break unless yes_or_no =~ /^y+e*s*$/i
end

