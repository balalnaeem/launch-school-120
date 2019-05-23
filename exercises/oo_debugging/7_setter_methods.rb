# playing around with the return value of setter methods

class Person
  attr_reader :name
  def name=(name)
    return 'Just causing some trouble!'
    @name = name
    @name.slice!(0, 2)
  end
end

balal = Person.new
p balal.name = 'Balal'
p balal.name