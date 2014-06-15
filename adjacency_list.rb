class AdjList
	def initialize vertex_hash, directed: false, broken_links: :ignore, weighted: false
		@adj_list = vertex_hash 
		@directed = directed
		@weighted = weighted
		@handle_broken_links = broken_links
		@broken_links = {}
		
		valid_edges?
	end

	def valid_edges?
		@adj_list.each do |vertex, vertex_list|
			vertex_list.each do |adj|
				 #p "Vertex #{vertex}, Edge to Vertex #{adj}"
				
				if !@adj_list.has_key? adj
					p "Missing: #{vertex} => #{adj}"
					handle_broken_links vertex, adj, :missing_vertex
				elsif !@directed && !@adj_list[adj].include?(vertex)
					handle_broken_links vertex, adj, :missing_ref
				end
			end
		end
	end

	private
	def handle_broken_links vertex, adj_vertex, type
		case @handle_broken_links 
		when :ignore
			if type == :missing_vertex
				p "Vertex #{adj_vertex} doesn't exist"
				@broken_links[vertex] = adj_vertex
			elsif type == :missing_ref
				p "Vertex #{adj_vertex} missing cross reference to #{vertex}" if type == :missing_ref
				@broken_links[adj_vertex] = vertex
			end
		when :fix
		when :prune
			if type == :missing_vertex
				p "Missing: Deleted #{vertex} => #{adj_vertex}"
				@adj_list[vertex].delete(adj_vertex)
				@broken_links[vertex] = adj_vertex
			elsif type == :missing_ref
				p "Cross Ref: Deleted #{vertex} => #{adj_vertex}"
				#@adj_list[vertex].delete(adj_vertex)
				#@broken_links[vertex] = adj_vertex
			end
		end
	end
end

#p AdjList.new({ 0 => [1], 1 => [0,2,3], 2 => [1], 3 => [0,1] })

vertices = {}
File.open("kargerMinCut_data_simple.txt").each_line do |line|
	vertex = line.gsub(/\s+/, ' ').strip.split(" ")
	vertex.map! { |i| i.to_i }
	c_v = vertex.shift
	vertex.sort!
	vertices[c_v] = vertex	
end
p AdjList.new(vertices, broken_links: :prune)


#adj_list = AdjList.new data
