class AdjList
	def initialize array_of_vertices, directed: false, broken_links: :ignore, weighted: false
		@adj_list = array_of_vertices
		@directed = directed
		@weighted = weighted
		@handle_broken_links = broken_links
		@broken_links = {}
		
		valid_edges?
	end

	def valid_edges?
		@adj_list.each do |vertex|
			current_vertex = vertex[0]
			vertex.each do |adj|
				# p "Vertex #{current_vertex}, Edge to Vertex #{adj}"
				
				if @adj_list[adj].nil?
					handle_broken_links current_vertex, adj, :missing_vertex
				elsif !@directed && !@adj_list[adj].include?(current_vertex)
					handle_broken_links current_vertex, adj, :missing_ref
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
		end
	end
end

# p AdjList.new [ [0,1], [1,0,2,3], [2,1,4], [3,0,1] ]

data = []
File.open("kargerMinCut_data.txt").each_line do |line|
	vertex = []
	vertex = line.gsub(/\s+/, ' ').strip.split(" ")
	vertex.map! { |i| i.to_i }
	data << vertex
end

adj_list = AdjList.new data
