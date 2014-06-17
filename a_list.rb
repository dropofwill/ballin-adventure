require 'set'

class AdjList
	attr_accessor :vertex_hash, :min_cut, :min_cut_hash

	def initialize vertex_hash
		@vertex_hash = vertex_hash
		@min_cut = nil
		@min_cut_hash = nil
	end
	
	def prob_min_cut attempts = 100
		attempts.times do
			find_min_cut
		end
		@min_cut
	end

	def find_min_cut
		a_hash = @vertex_hash.dup
		while a_hash.count > 2
			vert1, vert2 = random_edge a_hash
			a_hash, temp_min_cut = contract_edge a_hash, vert1, vert2
		end
		@min_cut_hash = a_hash if @min_cut_hash.nil? || @min_cut > temp_min_cut
		@min_cut = temp_min_cut if @min_cut.nil? || @min_cut > temp_min_cut
	end

	def contract_edge hash, vert1, vert2
		# get ref to both verts
		edges = hash[vert1] + hash[vert2]
		vert = vert1 | vert2

		# delete self loops from both ref => []
		edges.select! do |edge|
			!vert.include? edge
		end

		hash.delete(vert1)
		hash.delete(vert2)
		hash[vert] = edges
		return hash, edges.count
	end

	def random_edge hash
		# random vertex in @vertex_hash
		vert1 = hash.keys.sample 
		# random adjacent vertex 
		vert2 = hash[vert1].sample

		hash.keys.each { |x| vert2 = x if x.include? vert2 }
		Set.new [vert2] unless vert2.is_a?(Set)
		
		return vert1, vert2
	end
end


#a_graph = {
	#Set.new([1]) => [2, 5, 10],
	#Set.new([2]) => [1, 8, 9],
	#Set.new([3]) => [4, 5, 6],
	#Set.new([4]) => [3],
	#Set.new([5]) => [1, 3, 7, 9, 10],
	#Set.new([6]) => [3, 7],
	#Set.new([7]) => [5, 6],
	#Set.new([8]) => [2, 10],
	#Set.new([9]) => [2, 5, 10],
	#Set.new([10]) => [1, 5, 8, 9]
#}

#a = AdjList.new(a_graph)
#p a.prob_min_cut
#p a.vertex_hash

vertices = {}
File.open("kargerMinCut_data.txt").each_line do |line|
	vertex = line.gsub(/\s+/, ' ').strip.split(" ")
	vertex.map! { |i| i.to_i }
	c_v = vertex.shift
	vertex.sort!
	ref = Set.new [c_v]
	vertices[ref] = vertex	
end

a = AdjList.new vertices
p a.prob_min_cut
p a.min_cut
p a.min_cut_hash.values
