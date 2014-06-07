class Array
  # Run merge_sort non-destructively to get inversions
  # This runs in O(NlogN) which is better than finding 
  # inversions naively O(N^2) so while the sort may semm
  # wasteful it turns out to be the most efficient way to
  # count the inversions.
  def inversions
    @inversions = 0
    self.merge_sort
    @inversions
  end

  # Recursively sorts the array by repeatadly splitting
  # it until a base case of length 1 and then merging 
  # them back in order. Has the side effect of counting
  # inversions along the way
  def merge_sort
    @inversions = 0
    recursive_split self.dup
  end

  # By flattening afterwards this is actually slower
  # than just doing: array = array.merge_sort
  def merge_sort!
    @inversions = 0
    sort = recursive_split self
    (self.clear << sort).flatten!
  end

  private
  def recursive_split array
    length = array.length

    if length <= 1
      return array
    end

    midpoint = (length/2).to_i
    right = array
    left = []

    (0...midpoint).each do
      left.push right.shift
    end

    right = recursive_split right
    left  = recursive_split left

    return merge right, left, length
  end

  def merge right, left, length
    merge = []
    
    while left.length > 0 && right.length > 0
      if right[0] < left[0]
        @inversions += left.length
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
end


=begin
data = []

File.open("inversion_data.txt").each_line do |line|
  data << line.chomp.to_i
end

p data.inversions
=end


# Test Cases for merge_sort, merge_sort!
=begin
a1 = [1,2,3,2,4,3]
a2 = [3,2,1,10,-4,-5,33]

m1 = a1.merge_sort
m2 = a2.merge_sort! 

p m1, m1 == [1,2,2,3,3,4]
p a1
p m2, m2 == [-5,-4,1,2,3,10,33]
p a2
=end


# Test Cases for inversions
=begin
p a3 = [1,3,5,2,4,6]
p a4 = (1..21).to_a
p a5 = (1..2).to_a.reverse

i1 = a3.inversions
i2 = a4.inversions
i3 = a5.inversions

p "----results----"
p i1, i1 == 3
p i2, i2 == 0
p i3, i3 == 1
=end