require "benchmark"
require_relative "inversion_counter"

class Array
	def quick_sort
		recursive_partition self.dup, 0, self.length-1
	end

	def quick_sort!
		recursive_partition! 0, self.length-1
	end

	def swap! i, j
		i_val, j_val = self[i], self[j]
		self[j], self[i] = i_val, j_val
	end

	private

	# Most important function in terms of impact on running time
	def choose_pivot range
		# range.first
		# range.last
		# Average O(nlogn)
		range.first+rand(range.size)
	end

	# The recursive call, takes the array and the bounds 
	# of the current partition
	def recursive_partition arr, low, high
		# The current partition of the array
		range = (low..high)
		
		# The pivot by which this recursive call will sort
		pivot_index = choose_pivot(range)
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
			greater_than_pivot = false
			
			while j <= high do
				if arr[j] <= pivot_value
					arr.swap! i, j
					i += 1
				else
					greater_than_pivot = true
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


# a2 = (0..1000000).to_a.shuffle(random: Random.new(1))


# Benchmark.bm(20) do |x|
# 	x.report("sys merge") { a2.sort }
# 	# x.report("my merge ") { a2.merge_sort }
# 	# x.report("my merge!") { a2.merge_sort }
# 	x.report("my quick ") { a2.quick_sort }
# end

a1 = (0..10).to_a.shuffle(random: Random.new(1))

sys = a1.sort
quick = a1.quick_sort

p quick
p sys == quick