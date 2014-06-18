require "forwardable"

class AdjList
	extend Forwardable
	def initialize vertex_hash, directed: false, weighted: false, broken_links: :ignore
		@adj_list = vertex_hash 
		@directed = directed
		@weighted = weighted
		@valid = nil
		@handle_broken_links = broken_links
		@broken_links = {}
		
		valid_edges?
		self
	end

	def_delegators :adj_list, :[], :[]=, :has_key?, :has_value?, :length
	attr_accessor :adj_list, :directed, :weighted, :valid, :handle_broken_links, :broken_links

	def valid_edges?
		@adj_list.each do |vertex, vertex_list|
			p "#{vertex} => #{vertex_list}"

			vertex_list.each do |adj|
				if !@adj_list.has_key? adj.keys[0]
					p "Vertex missing #{adj.keys[0]}"
					save_broken_link vertex, adj
				elsif !@directed && !@adj_list[adj].has_key?(vertex)
					p "Vertex cross reference"
					save_broken_link vertex, adj
				end
			end
		end
		handle_broken_links 
		@valid
	end
	
	def min_cuts
	end

	def contract_edge vertex_1, vertex_2
		
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
		when :add
			# TODO
		when :prune
			if !@broken_links.empty?
				@adj_list.each do |v, a_v| 
					sym_diff = @broken_links[v] - a_v | a_v - @broken_links[v]
					@adj_list[v] = sym_diff
				end
			end
			@valid = true
		end
	end
end

vertices = {}
File.open("data/kargerMinCut_data.txt").each_line do |line|
	vertex = line.gsub(/\s+/, ' ').strip.split(" ")
	vertex.map! { |i| i.to_i }
	c_v = vertex.shift
	vertex.sort!
	vertices[c_v] = vertex	
end
p vertices

#a = AdjList.new(vertices)
#a[1]


#adj_list = AdjList.new data
