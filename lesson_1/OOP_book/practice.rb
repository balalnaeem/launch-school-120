# USING CUSTOM CLASSES

class ValidateAgeError < StandardError ; end

# most often you will want to inherit from StandardError

def validate_age
  raise ValidateAgeError unless (0..105).include? age
end

begin
  validate_age(age)
rescue ValidateAgeError => e
  puts e.message
end