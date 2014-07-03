class Array
  def mode
    freq = inject(Hash.new(0)) { |h,v| h[v] += 1; h }
    max = freq.values.max
    freq.select { |k, f| f == max } 
  end

  def most_common n=10
    freq = inject(Hash.new(0)) { |h,v| h[v] += 1; h }
    max = freq.values.sort[-n..-1]
    freq.select { |k, f| max.include? f } 
  end
end

def test_random n=20, i=1000
  nums = []
  times = []
  i.times do |x|
    count = 0
    until nums.count == 20
      nums << rand(0..n)
      nums = nums.uniq
      count +=1
    end
    times << count
    nums = []
  end
  return times
end

times = test_random 20, 1000000
#times = test_random 
times.sort!
count = times.count
total = times.inject(:+)
mean = total.to_f / count
median = count % 2 == 1 ? times[count/2] : (times[count/2 - 1] + times[count/2]).to_f / 2
p "Max: #{times.max}"
p "Min: #{times.min}"
p "Mean: #{mean}"
p "Median: #{median}"
p "Mode: #{times.mode}"
p "Most Common: #{times.most_common}"

=begin
Results on (0..20), 1,000,000 times
"Max: 198"
"Min: 22"
"Mean: 55.527856"
"Median: 53.0"
"Most Common: {45=>29328, 46=>30014, 47=>30693, 48=>31185, 49=>30837, 50=>31528, 51=>31216, 52=>30555, 53 =>29884, 54=>29133}"
=end
