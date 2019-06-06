def decrease(counter)
  counter -= 1
end

counter = 10

9.times do
  puts counter
  decrease(counter)
end

puts 'LAUNCH!'