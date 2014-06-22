require_relative "deep_dup"

# Adjacency List Data Structure
class Graph
	attr_accessor :verts
	Vertex = Struct.new(:name, :neighbours, :dist, :exp?)

	# Takes an array of feature arrays
	def initialize graph

		# Setup the default to be a Vertex
		#@verts = Hash.new{|h,k| h[k]=Vertex.new(k,[],Float::INFINITY,false)}
		@verts = Array.new

		cur_vert = nil
		tmp_vert = nil
		cur_adj =	 Array.new

		graph.each do |vertex|
			cur_vert = vertex[0] if cur_vert.nil?
			tmp_vert = vertex[0]
			p vertex
			p vertex[0]
			p vertex[1]
			p "Cur Vert #{cur_vert} Tmp Vert #{tmp_vert}"
			p "Cur Adj #{cur_adj}"

			# wait until a new vert appears to create the struct
			if cur_vert == tmp_vert
				cur_adj << vertex[1]
				p "Cur Adj delayed at #{cur_adj}"
			else
				p "Cur Adj added with #{cur_adj}"
				@verts.push(Vertex.new(cur_vert, cur_adj,Float::INFINITY,false))
				pp verts
				cur_vert = tmp_vert
				cur_adj.clear
				cur_adj << vertex[1]
			end
		end
	end

	def top_scc num=5
		@sccs = Array.new(num, 0)
	end


	def dfs_loop graph
		@t = 0
		@s = nil
	end

	def dfs graph, init_vert

	end
end


require "pp"
require "benchmark"


g = Graph.new([[:a, :b], [:a, :c], [:a, :d], [:b, :d], [:c, :d]])
pp g.verts


#data = []
#current_line = 1
#current_adj = []
#File.open("data/SCC_simple.txt").each_line do |line|
	#vertex = line.gsub(/\s+/, ' ').strip.split(" ")
	#vertex.map! { |i| i.to_i }

	#if vertex[0] == current_line
		#current_adj << vertex[1]
	#else
		#data << [current_line, current_adj] unless current_adj.empty?
		#current_line += 1
		#current_adj = [vertex[1]]
	#end
#end

#pp Graph.new data

#data = []

#Benchmark.bmbm do |x|
	#x.report("read data") do
		#File.open("data/SCC.txt").each_line do |line|
			#vertex = line.split(" ")
			#vertex.map! { |i| i.to_i }
			#data << vertex
		#end
	#end

	#x.report("load data") do 
		#Graph.new data
	#end
#end
