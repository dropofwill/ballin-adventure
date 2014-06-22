require_relative "deep_dup"

class AdjList
	attr_accessor :vertex_hash
	
	def initialize vertex_hash
		@vertex_hash = vertex_hash
	end

	def dfs init_vertex
		hash = @vertex_hash.deep_dup
		internal_dfs hash, init_vertex
	end

	def topo_sort
		hash = @vertex_hash.deep_dup
		graph = {}
		p order = hash.count

		hash.each do |vert, adj|
			if ! hash[vert][:explored]
				pp tmp_graph = internal_dfs(hash, vert, graph, order)
				graph.merge!(tmp_graph)
			end
		end

		return graph
	end

	private
	def internal_dfs hash, init_vertex, graph = {}, order = nil
		tmp_v = hash[init_vertex][:verts]
		tmp_e = hash[init_vertex][:explored] = true

		add_vertex graph, init_vertex, tmp_v, tmp_e

		adj_verts = hash[init_vertex][:verts]
			
		adj_verts.each do |adj|
			if ! hash[adj][:explored]
				if order.nil?
					internal_dfs hash, adj, graph
				else
					internal_dfs hash, adj, graph, order
				end
			end
		end

		p order
		graph[init_vertex][:order] = order unless order.nil?
		order -= 1 unless order.nil?

		return graph
	end

	def add_vertex hash, vertex, verts = nil, explored = nil, dist = nil
		hash[vertex] = {}
		hash[vertex][:verts]		= verts unless verts.nil?
		hash[vertex][:explored] = explored unless explored.nil?
		hash[vertex][:dist]			= verts unless dist.nil?
		return hash
	end
end

a_graph = {
	1		=> { verts: [2, 5, 10],				explored: false },
	2		=> { verts: [1, 8, 9],				explored: false },
	3		=> { verts: [4, 5, 6],				explored: false },
	4		=> { verts: [3],							explored: false },
	5		=> { verts: [1, 3, 7, 9, 10], explored: false },
	6		=> { verts: [3, 7],						explored: false },
	7		=> { verts: [5, 6],						explored: false },
	8		=> { verts: [2, 10],					explored: false },
	9		=> { verts: [2, 5, 10],				explored: false },
	10	=> { verts: [1, 5, 8, 9],			explored: false },
	11  => { verts: [],								explored: false }
}

require "pp"

a = AdjList.new a_graph
#pp a.dfs 1
#pp a.vertex_hash

pp a.topo_sort
