class Object
  # Can you safely dup this object?
  # true otherwise.
  def duplicable?
    true
  end
end

class NilClass
  # +nil+ is not duplicable:
  def duplicable?
    false
  end
end

class FalseClass
  # +false+ is not duplicable:
  def duplicable?
    false
  end
end

class TrueClass
  # +true+ is not duplicable:
  def duplicable?
    false
  end
end

class Symbol
  # Symbols are not duplicable:
  def duplicable?
    false
  end
end

class Numeric
  # Numbers are not duplicable:
  def duplicable?
    false
  end
end

require 'bigdecimal'
class BigDecimal
  begin
    BigDecimal.new('4.56').dup

    def duplicable?
      true
    end
  rescue TypeError
    # can't dup, so use superclass implementation
  end
end

class Object
  # Returns a deep copy of object if it's duplicable. If it's
  # not duplicable, returns +self+.
  #
  #   object = Object.new
  #   dup    = object.deep_dup
  #   dup.instance_variable_set(:@a, 1)
  #
  #   object.instance_variable_defined?(:@a) # => false
  #   dup.instance_variable_defined?(:@a)    # => true
  def deep_dup
    duplicable? ? dup : self
  end
end

class Array
  # Returns a deep copy of array.
  #
  #   array = [1, [2, 3]]
  #   dup   = array.deep_dup
  #   dup[1][2] = 4
  #
  #   array[1][2] # => nil
  #   dup[1][2]   # => 4
  def deep_dup
    map { |it| it.deep_dup }
  end
end

class Hash
  # Returns a deep copy of hash.
  #
  #   hash = { a: { b: 'b' } }
  #   dup  = hash.deep_dup
  #   dup[:a][:c] = 'c'
  #
  #   hash[:a][:c] # => nil
  #   dup[:a][:c]  # => "c"
  def deep_dup
    each_with_object(dup) do |(key, value), hash|
      hash[key.deep_dup] = value.deep_dup
    end
  end
end

#hash = { a: { b: 'b' } }
#dup  = hash.deep_dup
#dup[:a][:c] = 'c'

#p hash[:a][:c] # => nil
#p dup[:a][:c]  # => "c"

