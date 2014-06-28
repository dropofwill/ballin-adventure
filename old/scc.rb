require_relative "deep_dup"

# Adjacency List Data Structure
class Graph
  attr_accessor :graph
  Vertex = Struct.new(:name, :neighbours, :dist, :expl, :f_time)

  # Takes an array of feature arrays
  def initialize graph

    # Setup the default to be a Vertex
    @graph = Array.new
    @graph_rev = Array.new
    @t = 0
    @s = nil

    last_v = nil
    last_a = []
    graph.each do |vertex|
      last_v = vertex[0] if last_v.nil?

      if vertex[0] == last_v
        last_a << vertex[1]
      else
        # Create the Vertex with a dup of the array
        @graph << Vertex.new(last_v, last_a.deep_dup, Float::INFINITY, false, nil)
        last_a.clear << vertex[1]
        last_v = vertex[0]
      end
    end
    # Need to return the last element, since the loop would skip it
    @graph << Vertex.new(last_v, last_a, Float::INFINITY, false, nil)

    return @graph
  end

  def top_scc num=5
    @sccs = Array.new(num, 0)
  end

  def dfs_loop graph
    @t = 0
    @s = nil

    @graph_rev.each_with_index do |vertex,i|
      if ! vertex.expl 
        dfs @graph_rev, i 
      end
    end

    @graph.sort_by! { |x,y| x.f_time <=> y.f_time }
    
    @graph.each_with_index do |vertex,i|
      if ! vertex.expl 
        @s = i
        dfs @graph, i
      end
    end
  end

  def dfs graph, i
    @graph[i].expl = true
    @graph[i].neighbours.each do |n|
      if ! @graph[n].expl
        dfs @graph, n
      end
    end

    @graph[i].f_time = @t
    @t += 1
  end
end


require "pp"
require "benchmark"


g = Graph.new([[:a, :b], [:a, :c], [:a, :d], [:b, :d], [:c, :d]])
#g = Graph.new([{v: :a,e: :b},
               #{v: :a,e: :c},
               #{v: :a,e: :d},
               #{v: :b,e: :d},
       #        {v: :c,e: :d}]);
g.dfs g, 0 
pp g.graph


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
    #File.open("data/SCC_simple.txt").each_line do |line|
      #vertex = line.split(" ")
      #vertex.map! { |i| i.to_i }
      #data << vertex
    #end
  #end

  #x.report("load data") do 
    #g =  Graph.new data
  #end
#end
