module Armor
  def attach_armor
    # some code
  end

  def remove_armor
    # some_code
  end
end

module SpellCasting
  def cast_spell(spell)
    # some code
  end
end


class Player
  def initialize(name)
    @name = name
    @health = 100
    @strength = roll_dice
    @intelligence = roll_dice
  end

  def heal(val)
    @health += val
  end

  def hurt(val)
    @health -= val
  end

  def to_s
    ["Name : #{@name}", "Class : #{self.class}", "Health : #{@health}", "Strength : #{@strength}", "Intelligence : #{@intelligence}"]
  end

  private

  def roll_dice
    rand(2..12)
  end
end

class Warrior < Player
  include Armor
  def initialize(name)
    super
    @strength += 2
  end
end

class Paladin < Player
  include Armor
  include SpellCasting
end

class Magician < Player
  include SpellCasting
  def initialize(name)
    super
    @intelligence += 2
  end
end

class Bard < Magician
  def create_potions
    # some code
  end
end

balal = Bard.new("Balal")
puts balal.to_s