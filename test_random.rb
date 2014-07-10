require "benchmark"

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
  nums = {}
  times = []

  i.times do |x|
    count = 0
    until nums.size == n
      nums[rand(0..n)] = true
      count +=1
    end
    times << count
    nums.clear
  end
  return times
end

def test_random_mike n=20, i=1000
  nums = {}
  times = []

  i.times do |x|
    count = 0

    (1..n).to_a.each { |i| nums.merge!(i => false) }

    while nums.values.include? false
      nums[rand(0..n)] = true
      count +=1
    end
    times << count
    nums.clear
  end
  return times
end

num_pics = 20
num_trials = 1000000

=begin
times = test_random_mike num_pics, num_trials
#times = test_random num_pics, num_trials
times.sort!

total = times.inject(:+)
mean = total.to_f / num_trials
median = num_trials % 2 == 1 ? times[num_trials/2] : (times[num_trials/2 - 1] + times[num_trials/2]).to_f / 2
p "Max: #{times.max}"
p "Min: #{times.min}"
p "Mean: #{mean}"
p "Median: #{median}"
p "Mode: #{times.mode}"
p "Most Common: #{times.most_common}"
=end

=begin
Results on (0..20), 1,000,000 times
"Max: 198"
"Min: 22"
"Mean: 55.527856"
"Median: 53.0"
"Most Common: {45=>29328, 46=>30014, 47=>30693, 48=>31185, 49=>30837, 50=>31528, 51=>31216, 52=>30555, 53 =>29884, 54=>29133}"
=end

Benchmark.bm(2) do |x|
	x.report("Mike's Version") { test_random_mike num_pics, num_trials }
	x.report("Will's Versio")  { test_random num_pics, num_trials }
end

=begin
Results of benchmark:
         user     system      total        real                                                                           
Mike's Version    210.760000   3.920000 214.680000 (216.012779)                                                               
Will's Versio      34.540000   0.030000  34.570000 ( 34.617375)
=end

