module Towable
  def can_tow?(weight_pounds)
    weight_pounds <= 2000 ? true : false
  end
end

class Vehicle
  @@number_of_vehicles = 0

  attr_accessor :color, :model
  attr_reader :year

  def self.gas_mileage(gallons, miles)
    "#{miles / gallons} miles per gallon of gas."
  end

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @current_speed = 0
    @@number_of_vehicles += 1
  end

  def speed_up(miles_per_hour)
    puts "You pressed the accelerator! Going fast!"
    @current_speed += miles_per_hour
  end

  def brake(miles_per_hour)
    puts "You pressed brake! Slowing down!"
    @current_speed -= miles_per_hour
  end

  def current_speed
    "You are going at #{@current_speed} mph."
  end

  def spray_paint=(new_color)
    puts "You car in #{new_color} is looking good!"
    self.color = new_color
  end

  def turn_off
    puts "Turning off the engine now."
    @current_speed = 0
  end

  def turn_off
    puts "Turning off the engine now."
    @current_speed = 0
  end

  def to_s
    "This is #{year} #{color} #{model}."
  end

  def self.total_vehicles
    @@number_of_vehicles
  end

  def age
    "Your #{model} is #{years_old} years old."
  end

  private

  def years_old
    Time.new.year - year
  end
end

class MyCar < Vehicle
  DOORS = 5
end

class MyTruck < Vehicle
  include Towable
  DOORS = 4
end

my_ford = MyCar.new(2007, 'blue', 'Ford Focus')
my_truck = MyTruck.new(2015, 'black', 'Mitsubishi Outlander')

puts my_truck.age









