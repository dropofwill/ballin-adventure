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
		range.last
	end

	# The recursive call, takes the array and the bounds 
	# of the current partition
	def recursive_partition arr, low, high
		# The current partition of the array
		range = (low..high)
		# The pivot by which this recursive call will sort
		pivot_index = choose_pivot(range)
		pivot_value = arr[pivot_index]
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

	# Version that works on self instead of an duplicate
	def recursive_partition! low, high
		range = (low..high)
		pivot_index = choose_pivot(range)
		pivot_value = self[pivot_index]
		i = j = low

		if range.size <=2
			swap!(i, i+1) if self[i+1] < self[i]
		else
			while j <= high do
				if self[j] <= pivot_value
					swap! i, j
					i += 1
				end
				j += 1
			end

			swap! pivot_index, i-1
			pivot_index = i-1

			recursive_partition!(low, pivot_index-1) unless low >= pivot_index-1
			recursive_partition!(pivot_index+1, high) unless pivot_index+1 >= high
		end
	end
end




a2 = (1..10).to_a.shuffle
sys = a2.sort
quick = a2.quick_sort
a2.quick_sort!

p quick

p sys == a2, sys == quick