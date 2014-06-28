def adjacent_sums data, target_sum = 80
	answers = []
	data.each_with_index do |x, i|
		j = total = 0
		temp_ith_entries = []

		until total >= target_sum || j+i >= data.length
			p "length: #{data.length}, i: #{i}, j: #{j}, i+j #{i+j}"
			total += data[i+j]
			temp_ith_entries << (i+j)
			j += 1
		end	

		if total == target_sum
			answers << temp_ith_entries
		end	
	end
	return answers
end

data = []
f = File.open("parsed.txt") or die "Unable to open file..."
f.each_line do |line| 
	data << line.gsub("\$", "").to_f 
end

#p data
#data = [1,2,3,4,5,6]

p adjacent_sums data, 80.20 
