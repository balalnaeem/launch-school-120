  def total(values)
    total_val = 0
    values.each do |v|
      if ['J', 'K', 'Q'].include?(v)
        total_val += 10
      elsif v.is_a? Integer
        total_val += v
      else
        total_val += 11
      end
    end
    values.count('A').times do
      total_val -= 10 if total_val > 21
    end
    total_val
  end

  p total(values)