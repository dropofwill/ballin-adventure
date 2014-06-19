require_relative "queue"

class AdjList
	attr_accessor :vertex_hash
	
	def initialize vertex_hash
		@vertex_hash = vertex_hash
	end

	def bfs_search init_vertex
		hash = @vertex_hash.dup
		cur_dist = 0
		
		q = Queue.new init_vertex
		hash[init_vertex][:explored] = true

		while q.count != 0
			cur_vertex = q.deq	
			adj_verts = hash[cur_vertex][:verts]
			hash[cur_vertex][:dist] = cur_dist
			
			adj_verts.each do |adj|
				if !hash[adj][:explored]
					hash[adj][:explored] = true
					q.enq adj
				end
			end

			cur_distant += 1
		end
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
	10	=> { verts: [1, 5, 8, 9],			explored: false }
}

a = AdjList.new a_graph
p a.vertex_hash
a.bfs_search 1
p a.vertex_hash 
