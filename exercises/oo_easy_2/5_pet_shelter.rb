class Shelter
  @@pets_and_status = {}

  def initialize
    @owners_pets_register = {}
  end

  def self.add_pet(pet)
    @@pets_and_status[pet] = :unadopted
  end

  def adopted_pets
    @@pets_and_status.select { |_, status| status == :adopted }.keys
  end

  def unadopted_pets
    @@pets_and_status.select { |_, status| status == :unadopted }.keys
  end

  def total_pets
    @@pets_and_status
  end

  def print_adoptions
    puts "#{adopted_pets.size} pets have been adopted. Details below:"
    puts
    @owners_pets_register.each do |owner, pets|
      puts "#{owner.name} has adopted the following pets:"
      puts pets
      puts
    end
  end

  def print_unadopted_pets
    puts
    puts "We heva #{unadopted_pets.size} unadopted pets:"
    puts unadopted_pets
    puts
  end

  def adopt(owner, pet)
    @@pets_and_status[pet] = :adopted
    owner.pets << pet

    @owners_pets_register[owner] ||= []
    @owners_pets_register[owner] << pet
  end
end

class Pet
  attr_reader :animal, :name

  def initialize(animal, name)
    @animal = animal
    @name = name
    Shelter.add_pet(self)
  end

  def to_s
    "A #{animal} named #{name}"
  end
end

class Owner
  attr_reader :name, :pets

  def initialize(name)
    @name = name
    @pets = []
  end

  def number_of_pets
    @pets.size
  end
end

butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')
asta         = Pet.new('dog', 'Asta')
laddie       = Pet.new('dog', 'Laddie')
fluff        = Pet.new('cat', 'Fluff')
kat          = Pet.new('cat', 'Kat')

phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')

shelter = Shelter.new

shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)

shelter.print_adoptions
shelter.print_unadopted_pets
puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."
