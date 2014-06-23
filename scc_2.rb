require_relative "deep_dup"

# Adjacency List Data Structure
class Graph
  attr_accessor :graph, :rev
  Vertex = Struct.new(:name, :neighbours, :dist, :expl, :f_time)

  # Takes an array of feature arrays
  def initialize graph
    @graph = Hash.new{|h,k| h[k]=Vertex.new(k,[],Float::INFINITY,false,nil)}
    @rev = @graph.deep_dup
    @t = 0
    @s = nil
    @f_times = []

    graph.each do |(v1,v2)|
      @graph[v1].neighbours << v2
      @rev[v2].neighbours   << v1
    end
    return @graph
  end

  def top_scc num=5
    @sccs = Array.new(num, 0)
  end

  def dfs_loop graph
    @t = 0
    @s = nil
    @f_times = []

    @rev.each do |key,vertex|
      if ! vertex.expl 
        dfs @rev, vertex 
      end
    end

    @f_times.reverse.each_with_index do |f_time, i|
      if ! vertex.expl 
        @s = i
        dfs @graph, f_time[i] 
      end
    end
  end

  def dfs graph, i
    graph[i].expl = true
    graph[i].neighbours.each do |n|
      if ! graph[n].expl
        dfs graph, n
      end
    end

    @t += 1
    graph[i].f_time = @t
    @f_times.push({@t => i})
  end
end


require "pp"
require "benchmark"


g = Graph.new([[:a, :b], [:a, :c], [:a, :d], [:b, :d], [:c, :d]])
g.dfs_loop g.graph
pp g.graph
pp g.rev


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
