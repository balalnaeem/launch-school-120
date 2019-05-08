class Cat
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def rename(new_name)
    @name = new_name
  end

  def identity
    self
  end
end

kitty = Cat.new('Sophie')
p kitty