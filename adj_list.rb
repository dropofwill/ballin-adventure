class AdjList
	attr_accessor :verts, :edges

	def initialize vertices, edges
		@verts = vertices
		@edges = edges
	end
end

class Vertex
	attr_accessor :edges
	def initialize *edges
		@edges = edges.select { |e| e.is_a? Edge }
	end

	def add_edges *edges
		@edges << edges.select { |e| e.is_a? Edge }
	end
end

class Edge
	attr_accessor :verts
	def initialize vert1 = nil, vert2 = nil
		@verts = [vert1, vert2] unless !vert1.is_a?(Vertex) || !vert2.is_a?(Vertex)
	end
end


verts = {}
edges = []
adj_verts = []
File.open("kargerMinCut_data.txt").each_line do |line|
	vertex = line.gsub(/\s+/, ' ').strip.split(" ")
	vertex.map! { |i| i.to_i }
	c_v = vertex.shift
	verts[c_v] = Vertex.new	
	
	vertex.sort!
	adj_verts << vertex
end

adj_verts.each_with_index do |e, i|
	i += 1
	e.each do |x|
		an_edge = Edge.new(verts[i],verts[x])
		edges << an_edge
		verts[i].add_edges an_edge
		verts[x].add_edges an_edge
	end
end

puts "Verts:"
p verts

puts "Edges:"
p edges





#verts = []
#edges = []
#20.times do
	#verts << Vertex.new
#end
#p verts
#p verts.length

#2.times do
	#p a = rand(0...20)
	#p b = rand(0...20)
	#e = Edge.new(verts[a],verts[b])
	#verts[a].add_edges e
	#verts[b].add_edges e
	#edges << e
#end
#p verts
