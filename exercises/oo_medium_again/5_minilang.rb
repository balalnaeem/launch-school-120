class Minilang < StandardError
  LANGUAGE = %w(PUSH ADD SUB MULT DIV MOD POP PRINT)

  attr_reader :operation

  def initialize(operation)
    @operation = transform(operation)
    @stack = []
    @register = 0
  end

  def transform(input)
    input.split(' ').map do |element|
      if element =~ /\d/
        element.to_i
      else
        element
      end
    end
  end

  def eval
    operation.each do |op|
      unless op.is_a?(Integer) || LANGUAGE.include?(op)
        raise SyntaxError.new("Invalid Process: #{op}")
      end
      op.is_a?(Integer) ? @register = op : send(op.downcase)
    end
  end

  def add
    @register += @stack.pop
  end

  def sub
    @register -= @stack.pop
  end

  def mult
    @register *= @stack.pop
  end

  def push
    @stack << @register
  end

  def div
    @register /= @stack.pop
  end

  def mod
    @register %=@stack.pop
  end

  def pop
    raise IndexError.new("Empty stack!") if @stack.empty?
    @register = @stack.pop
  end

  def print
    puts @register
  end
end


Minilang.new('PRINT').eval
# 0

Minilang.new('5 PUSH 3 MULT PRINT').eval
# # 15

Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# # 5
# # 3
# # 8

Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# # 10
# # 5
begin
  Minilang.new('5 PUSH POP POP PRINT').eval
rescue => e
  puts e
end
# # Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# # 6

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# # 12
begin
  Minilang.new('-3 PUSH 5 XSUB PRINT').eval
rescue SyntaxError => e
  puts e
end
# # Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# # 8

# Minilang.new('6 PUSH').eval
# # (nothing printed; no PRINT commands)