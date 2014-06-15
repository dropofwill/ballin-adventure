class AdjList
	def initialize vertex_hash, directed: false, broken_links: :ignore, weighted: false
		@adj_list = vertex_hash 
		@directed = directed
		@weighted = weighted
		@valid = nil
		@handle_broken_links = broken_links
		@broken_links = {}
		
		valid_edges?
	end

	def valid_edges?
		@adj_list.each do |vertex, vertex_list|
			p "#{vertex} => #{vertex_list}"
			vertex_list.each do |adj|
				p "Missing: #{vertex} => #{adj}"

				if !@adj_list.has_key? adj
					save_broken_link vertex, adj
				elsif !@directed && !@adj_list[adj].include?(vertex)
					save_broken_link vertex, adj
				end
			end
		end
		handle_broken_links 
		@valid
	end

	private
	def save_broken_link vertex, adj_vertex
		if @broken_links[vertex].nil? 
			@broken_links[vertex] = [adj_vertex]
		else
			@broken_links[vertex] << adj_vertex
		end
	end

	def handle_broken_links 
		case @handle_broken_links 
		when :ignore
			@broken_links.empty? ? @valid = true : @valid = false
		when :fix
		when :prune
			@adj_list.each do |v, a_v| 
				sym_diff = @broken_links[v] - a_v | a_v - @broken_links[v]
				p @adj_list[v] = sym_diff
			end
			@valid = true
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
