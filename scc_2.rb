require_relative "deep_dup"
require_relative "stack"

# Adjacency List Data Structure
class Graph
  attr_accessor :graph, :rev
  Vertex = Struct.new(:name, :neighbours, :expl, :f_time, :leader)

  # Takes an array of feature arrays
  def initialize graph
    # Make the data entry easier with default hash values
    @graph = Hash.new{|h,k| h[k]=Vertex.new(k,[],false,nil,nil)}
    @rev   = Hash.new{|h,k| h[k]=Vertex.new(k,[],false,nil,nil)}
    @t = 0
    @s = nil
    @f_times = []

    graph.each do |(v1,v2)|
      @graph[v1].neighbours << v2
      @graph[v2]
      @rev[v2].neighbours   << v1
      @rev[v1]
    end

    # Set the hash back to its safe default
    @graph.default = @rev.default = nil
    return @graph
  end

  def top_scc num=5
    @sccs = Array.new(num, 0)
  end

  def dfs_loop graph
    @t = 0
    @s = nil
    @s_count = 0
    @f_times = []
    @sccs = Array.new(5, 0)
    
    @rev.each do |key,vertex|
      #p "Outside check, Key: #{key} Value #{vertex}"
      if ! vertex.expl 
        dfs @rev, key, :rev
      end
    end
    p @f_times

    @f_times.reverse.each do |f_time|
      if ! @graph[f_time[1]].expl 
        @s = f_time[0]
        dfs @graph, f_time[1], :for
      end
      @sccs << @s_count
      @s_count = 0
      @sccs.sort! { |x,y| y <=> x }
      @sccs = @sccs[0..4]
    end
    return @sccs
  end

  def dfs graph, key, dir = nil
    p key
		s = Stack.new key

    if dir == :for
      graph[key].leader = @s 
      @s_count += 1
    end

    while s.size > 0
      key = s.pop
      p key
      graph[key].expl = true
      graph[key].neighbours.each do |n|

        if ! graph[n].expl
          if dir == :for
            graph[key].leader = @s 
            @s_count += 1
          end

          #graph[n].expl = true
          s.push n
        end
      end

      if dir == :rev
        @t += 1
        graph[key].f_time = @t
        @f_times.push([@t, key])
      end

      p "Neighbour: #{key} #{graph[key]}"
    end
  end
end


require "pp"
require "benchmark"

data = []
File.open("data/SCC_2.txt").each_line do |line|
  vertex = line.gsub(/\s+/, ' ').strip.split(" ")
  vertex.map! { |i| i.to_i }
  data << [vertex[0], vertex[1]]
end

graph1 = Graph.new data
p graph1.dfs_loop graph1
#pp graph1


#g = Graph.new([[:a, :b], [:a, :c], [:a, :d], [:b, :d], [:c, :d]])
#g.dfs_loop g.graph
#pp g.graph
#pp g.rev


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
