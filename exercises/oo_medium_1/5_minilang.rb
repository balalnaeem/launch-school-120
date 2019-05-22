class Minilang
  attr_accessor :stack, :register, :commands

  def initialize(input)
    @commands = input.split
    @stack = []
    @register = 0
  end

  def eval
    current_command = nil
    loop do
    # loop do
    #   current_command = commands.shift
    #   case current_command
    #   when 'PUSH'  then push
    #   when 'ADD'   then add
    #   when 'SUB'   then sub
    #   when 'MULT'  then mult
    #   when 'DIV'   then div
    #   when 'MOD'   then mod
    #   when 'POP'   then pop
    #   when 'PRINT' then print
    #   when /[0-9]/ then num(current_command.to_i)
    #   else break puts "Invalid Token: #{current_command}"
    #   end
    #   break if commands.empty?
    # end
  end

  def num(val)
    self.register = val
  end

  def push
    stack << register
  end

  def add
    self.register += stack.pop
  end

  def sub
    self.register -= stack.pop
  end

  def mult
    self.register *= stack.pop
  end

  def div
    self.register = register / stack.pop
  end

  def mod
    self.register = register % stack.pop
  end

  def pop
    if stack.empty?

    end
    self.register = stack.pop
  end

  def print
    p register
  end
end

Minilang.new('5 PUSH POP POP PRINT').eval

=begin
  first I convert the input string into an array of separate string elements(commands)
  intialize the stack to empty array
  intialize the register to zero

=end