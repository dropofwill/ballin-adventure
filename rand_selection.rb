require_relative 'deep_dup'

class Array
	# Modified version of Quick Sort to find the ith smallest element
	# of an array. With random pivots it runs on average O(n)
	
	def rselect ith
		recursive_rselect self.deep_dup, 0, self.length-1, ith
	end

	def swap! i, j
		i_val, j_val = self[i], self[j]
		self[j], self[i] = i_val, j_val
	end

	private
	def recursive_rselect arr, low, high, ith
		range = (low..high)

		# The pivot by which this recursive call will sort
		pivot_index = choose_pivot range
		pivot_value = arr[pivot_index]
		
		# Move the pivot to the beginning of the partition 
		arr.swap! pivot_index, low
		pivot_index = low

		# i is the index keeping track of where the pivot should be moved
		# j is the index keeping track of our pass through the partition
		i = j = low

		# Base case when there are just two elements then brute force it
		if range.size == 1
			return arr[range.first]
		elsif range.size ==2
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

			if pivot_index == ith
				return arr[pivot_index]
			elsif pivot_index > ith
				return recursive_rselect(arr, low, pivot_index-1, ith)
			elsif pivot_index < ith
				return recursive_rselect(arr, pivot_index+1, high, ith)
			end
		end
	end

	def choose_pivot range
		range.first+rand(range.size)
	end
end

a1 = (0..10000).to_a
p a1.rselect a1.length/2
# p [1,2,3].rselect length/2
