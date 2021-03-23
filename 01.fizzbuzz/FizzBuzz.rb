100.times do |i|
  count = 1 + i
  if count % 3 == 0 && count % 5 == 0
    puts "FizzBuzz"
  elsif
    count % 3 == 0
    puts "Fizz"
  elsif
    count % 5 == 0
    puts "Buzz"
  else
    puts count
  end
end
