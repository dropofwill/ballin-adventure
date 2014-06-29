require_relative "deep_dup"

# Adjacency List Data Structure
class Graph
  attr_accessor :graph, :rev
  Vertex = Struct.new(:name, :neighbours, :expl)

  # Takes an array of feature arrays
  def initialize graph
    # Make the data entry easier with default hash values
    @graph = Hash.new{|h,k| h[k]=Vertex.new(k,[],false)}
    @edges = {}

    graph.each do |(v1,v2,weight)|
      @graph[v1].neighbours << v2
      @graph[v2]
      @edges[[v1,v2]] = weight
    end

    # Set the hash back to its safe default
    @graph.default = nil
    return @graph, @edges
  end

  def dijkstra graph

  end

  def dfs graph, key, dir = nil
    p key
    graph[key].expl = true

    if dir == :for
      graph[key].leader = @s 
      @s_count += 1
    end

    #p "DFS init: #{graph[key]}"

    graph[key].neighbours.each do |n|
      #p "Neighbour: #{n} #{graph[:a]}"
      if ! graph[n].expl
        dfs graph, n, dir
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


require "pp"
require "benchmark"

data = []
File.open("data/dijk_data_simple.txt").each_line do |line|
  vertex = line.gsub(/\s+/, ' ').strip.split(" ")
  v1 = vertex.shift
  p v1
  vertex.each do |pair|
    pair = pair.split(",")
    pair = [v1, pair[0], pair[1]]
    pair.map! { |i| i.to_i }
    data << pair
  end
end
pp data

graph1 = Graph.new data
pp graph1
#p graph1.dfs_loop graph1

