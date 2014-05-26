def merge_sort array
	length = array.length

	if length <= 1
		return array
	end

	midpoint = (length/2).to_i
	right = array
	left = []

	(0...midpoint).each do
		left.unshift right.shift
	end

	right = merge_sort right
	left = merge_sort left

	return merge right, left, length
end

def merge right, left, length
	merge = []
	
	while left.length > 0 && right.length > 0
		if right[0] < left[0]
			merge.push right.shift
		elsif left[0] < right[0]
			merge.push left.shift
		else
			merge.push right.shift
		end
	end

	if left.length == 0
		merge = merge + right
	elsif right.length == 0
		merge = merge + left
	end

	return merge
end

# Test Cases
m1 = merge_sort [1,2,3,2,4,3]
m2 = merge_sort [3,2,1,10,-4,-5,33]

p m1, m1 == [1,2,2,3,3,4]
p m2, m2 == [-5,-4,1,2,3,10,33]