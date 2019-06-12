class Student
  def initialize(name='Visitor', year='N/A')
    @name = name
    @year = year
  end
end

class Graduate < Student
  def initialize(name, year, parking)
    super(name, year)
    @parking = parking
  end
end

class Undergraduate < Student; end

class Visitor < Student
  def initialize
    super()
  end
end