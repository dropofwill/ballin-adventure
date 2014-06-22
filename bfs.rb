require_relative "queue"
require_relative "deep_dup"

class AdjList
	attr_accessor :vertex_hash
	
	def initialize vertex_hash
		@vertex_hash = vertex_hash
	end

	def bfs init_vertex
		hash = @vertex_hash.deep_dup
		internal_bfs hash, init_vertex
	end

	def find_clusters
		hash = @vertex_hash.deep_dup
		clusters = []

		hash.each do |key, data|
			if ! data[:explored]
				clusters << internal_bfs(hash, key)
			end
		end
		return clusters
	end

	private
	def internal_bfs hash, init_vertex
		q = Queue.new init_vertex
		graph = {}

		tmp_v = hash[init_vertex][:verts]
		tmp_e = hash[init_vertex][:explored] = true
		tmp_d = hash[init_vertex][:dist]     = 0

		add_vertex graph, init_vertex, tmp_v, tmp_e, tmp_d

		while q.size != 0
			cur_vertex = q.deq	
			adj_verts = hash[cur_vertex][:verts]
			
			adj_verts.each do |adj|
				if !hash[adj][:explored]
					tmp_v = hash[adj][:verts]
					tmp_e = hash[adj][:explored] = true
					tmp_d = hash[adj][:dist] = hash[cur_vertex][:dist] + 1
					add_vertex graph, adj, tmp_v, tmp_e, tmp_d
					q.enq adj
				end
			end
		end
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
p a.vertex_hash
p "BFS results on vert 1:"
pp a.bfs 1
#pp a.vertex_hash 

p "Cluster results:"
pp clusters = a.find_clusters

p "Number of clusters:"
p clusters.count
