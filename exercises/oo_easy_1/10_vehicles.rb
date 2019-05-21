class Vehicle
  attr_reader :make, :model, :playload
  def initialize(make, model, playload = nil)
    @make = make
    @model = model
    @playload = playload
  end
end

class Car
  def wheels
    4
  end
end

class Motorcycle
  def wheels
    2
  end
end

class Truck
  def wheels
    6
  end
end