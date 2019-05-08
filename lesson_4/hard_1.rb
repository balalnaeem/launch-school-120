module Moveable
  attr_accessor :speed, :heading
  attr_writer :fuel_efficiency, :fuel_capacity

  def range
    @fuel_capacity * @fuel_efficiency
  end
end

class WheeledVehicle
  include Moveable

  def initialize(tire_array, km_traveled_per_litre, litres_of_fuel_capacity)
    @tires = tire_array
    @fuel_efficiency = km_traveled_per_litre
    @fuel_capacity = litres_of_fuel_capacity
  end

  def tire_pressure(tire_index)
    @tires[tire_index]
  end

  def inflate_tire(tire_index, pressure)
    @tires[tire_index] = pressure
  end
end

class Auto < WheeledVehicle
  def initialize
    super([30, 30, 32, 32], 50, 25.0)
  end
end

class Motorcycle < WheeledVehicle
  def initialize
    super([20, 20], 80, 8.0)
  end
end

class Catamaran
  include Moveable
  attr_reader :propeller_count, :hull_count

  def initialize(num_propellers, num_hulls, km_traveled_per_litre, litres_of_fuel_capacity)
    @propeller_count = num_propellers
    @hull_count = num_hulls
    @fuel_efficiency = km_traveled_per_litre
    @fuel_capacity = litres_of_fuel_capacity
  end
end

class Motorboar < Catamaran
  def initialize(km_traveled_per_litre,  litres_of_fuel_capacity)
    super(1,1, km_traveled_per_litre, litres_of_fuel_capacity)
  end
end















