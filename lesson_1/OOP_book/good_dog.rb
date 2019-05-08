module  Walkable
  def walk
    "I'm walking!"
  end
end

module Climbable
  def climb
    "I'm climbing!"
  end
end

module Swimmable
  def swim
    "I'm swimming!"
  end
end

class Animal
  include Walkable
  include Climbable

  def speak
    "I am an animal an I speak."
  end
end

class Fish < Animal
  include Swimmable
end

module Mammal

  def self.some_method(num)
    num * 2
  end

  class Cat
    def say_name(name)
      puts "#{name}"
    end
  end

  class Dog
    def speak(sound)
      puts "#{sound}"
    end
  end
end

buddy = Mammal::Dog.new
kitty = Mammal::Cat.new

buddy.speak("Hello")
kitty.say_name("heehaa")

puts Mammal::some_method(2)


