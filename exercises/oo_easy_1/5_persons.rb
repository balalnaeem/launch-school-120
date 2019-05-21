class Person
  def initialize(first_name, last_name)
    @first_name = first_name.capitalize
    @last_name = last_name.capitalize
  end

  def to_s
    "#{@first_name} #{@last_name}"
  end

  def first_name=(f_name)
    @first_name = f_name.capitalize
  end

  def last_name=(l_name)
    @last_name = l_name.capitalize
  end
end

person = Person.new('john', 'doe')
puts person

person.first_name = 'jane'
person.last_name = 'smith'
puts person