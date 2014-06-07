require "benchmark"
require_relative "inversion_counter"

class Array
	def comparisons technique = "random"
		@comparisons = 0
		quick_sort technique
		@comparisons
	end

	def quick_sort technique = "random"
		@technique = technique
		@comparisons = 0
		recursive_partition self.dup, 0, self.length-1
	end

	def swap! i, j
		i_val, j_val = self[i], self[j]
		self[j], self[i] = i_val, j_val
	end

	private
	# Most important function in terms of impact on running time
	def choose_pivot range, arr
		# First as pivot
		if @technique == "first"
			range.first
		# Last as pivot
		elsif @technique == "last"
			range.last
		# Random pivot
		elsif @technique == "random"
			range.first+rand(range.size)
		# Median of three as pivot
		elsif @technique == "median"
			Array.median_of_three range, arr
		# Median of three as pivot
		elsif @technique == "median2"
			Array.median_of_three_2 range, arr
		end
	end

	def self.median_of_three range, arr
		f_i, l_i, s = range.first, range.last, range.size

		if s % 2 == 0
			m_i = s / 2 - 1
			m_i += f_i
		else
			m_i = s / 2 
			m_i += f_i
		end

		f, m, l = arr[f_i], arr[m_i], arr[l_i]

		if (m < f && m > l) || (m < l && m > f)
			median = m
		elsif (l < f && l > m) || (l < m && l > f)
			median = l
		elsif (f < l && f > m) || (f < m && f > l)
			median = f
		end

		return median
	end

	def self.median_of_three_2 range, arr
		f_i, l_i, s = range.first, range.last, range.size

		if s % 2 == 0
			m_i = s / 2 - 1
			m_i += f_i
		else
			m_i = s / 2
			m_i += f_i 
		end

		f, m, l = arr[f_i], arr[m_i], arr[l_i]

		if (f..l).include?(m) || (l..f).include?(m)
			median = m
		elsif (f..m).include?(l) || (m..f).include?(l)
			median = l
		else (l..m).include?(f) || (m..l).include?(f)
			median = f
		end

		return median
	end

	# The recursive call, takes the array and the bounds 
	# of the current partition
	def recursive_partition arr, low, high
		# The current partition of the array
		range = (low..high)
		@comparisons += range.size-1
		
		# The pivot by which this recursive call will sort
		pivot_index = choose_pivot(range, arr)
		pivot_value = arr[pivot_index]
		
		# Move the pivot to the beginning of the partition 
		arr.swap! pivot_index, low
		pivot_index = low

		# i is the index keeping track of where the pivot should be moved
		# j is the index keeping track of our pass through the partition
		i = j = low

		# Base case when there are just two elements then brute force it
		if range.size <=2
			arr.swap!(i, i+1) if arr[i+1] < arr[i]
		else
		# Otherwise scan through the partition looking for values less than
		# the pivot and swapping when this is the case
			while j <= high do
				if arr[j] <= pivot_value
					arr.swap! i, j
					i += 1
				end
				j += 1
			end

			arr.swap! pivot_index, i-1
			pivot_index = i-1

			recursive_partition(arr, low, pivot_index-1) unless low >= pivot_index-1
			recursive_partition(arr, pivot_index+1, high) unless pivot_index+1 >= high
		end

		return arr
	end
end



# Median of Three pivot selection tests
=begin
a1 = (0..10000).to_a.shuffle(random: Random.new(1))
p a1.comparisons "first"
p a1.comparisons "random"
p a1.comparisons "median2"
p a1.comparisons "median"
p Array.median_of_three((0..4), [1,5,3,4,5])
p Array.median_of_three((0..3), [1,2,3,4])
=end



# Algorithms I Problem Set 2, number of comparisons 
=begin

data = []
File.open("quick_sort_data.txt").each_line do |line|
  data << line.chomp.to_i
end

p "last: ", data.comparisons("last")
p "first: ", data.comparisons("first")
p "median: ", data.comparisons("median2")
p "random: ", data.comparisons("random")
=end



# Benchmarks of various sorting algorithms 
=begin
a2 = (0..1000000).to_a.shuffle(random: Random.new(1))
Benchmark.bm(20) do |x|
	x.report("sys merge") { a2.sort }
	# x.report("my merge ") { a2.merge_sort }
	# x.report("my merge!") { a2.merge_sort }
	x.report("my quick ") { a2.quick_sort }
end
=end

=begin
a2 = (0..10000).to_a.shuffle(random: Random.new(1))
Benchmark.bm(20) do |x|
	x.report("quick first ") { a2.quick_sort "first" }
	x.report("quick random") { a2.quick_sort "random" }
	x.report("quick median") { a2.quick_sort "median" }
	x.report("quick median2") { a2.quick_sort "median2" }
end
=end



# Test case
=begin
a1 = (0..10).to_a.shuffle(random: Random.new(1))
sys = a1.sort
quick = a1.quick_sort
p quick
p sys == quick
=end