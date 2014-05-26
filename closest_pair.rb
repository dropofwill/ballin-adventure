require_relative "inversion_counter"

# Simple data structure for storing an x and y value
class Vector
	attr_accessor :x, :y

	def initialize x, y
		@x = x
		@y = y
	end
end

# Simple data structure for storing 2 vectors and
# calculating the distance between them.
class Pair
	attr_reader :v1, :v2, :distance
	def initialize v1, v2
		@v1 = v1
		@v2 = v2
		@distance = calculate_distance
	end

	private
	def calculate_distance
		Math.sqrt((@v1.x + @v2.x)**2 + (@v1.y + @v2.y)**2)
	end
end

# Generate an array of test data
def generate_vectors size_range, int_range = (0..20)
	vector_array = []
	size_range.each do |i|
		vector_array << Vector.new(rand(int_range), rand(int_range))
	end
	return vector_array
end

# The function that kicks off the first recursive call
def closest_pair vector_array
	by_x = vector_array.sort_by { |e| e.x }
	by_y = vector_array.sort_by { |e| e.y }

	array, best = recursive_split by_x
	p "Da #{best.distance}"
end

def recursive_split array, best_pair = nil
	length = array.length

	if length <= 3
		best = brute_force_closest_pair array

		return array, best
	end

	midpoint = (length/2).to_i
  right = array
  left = []

  (0...midpoint).each do
		left.push right.shift
  end

  right, right_best = recursive_split right
  left, left_best  = recursive_split left
  # split_best = closest_split_pair array

  return right + left, left_best.distance < right_best.distance ? left_best : right_best
end


def brute_force_closest_pair array
	length = array.length
	best = nil

	(0...length).each do |i|
		(i...length).each do |i2|
			print "#{i} #{i2}: "

			if i != i2
				a_pair = Pair.new(array[i], array[i2])
				best = a_pair if best.nil? || a_pair.distance < best.distance
			end

			p best.distance unless best.nil?
		end
	end

	return best
end

# brute_force_closest_pair generate_vectors (0..3)
# brute_force_closest_pair [Vector.new(0,1)]
closest_pair generate_vectors (0..5)