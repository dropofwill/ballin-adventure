require_relative "deep_dup"
require_relative "stack"

class Graph
  attr_accessor :graph
  Vertex = Struct.new(:length, :dir, :joint_dir, :joint_dirs)

  def initialize graph, x = 2, y = 2, z = 2
    @graph = []
    @max_x, @max_y, @max_z = x, y, z

    graph.each do |arr|
      @graph << Vertex.new(arr[0], arr[1], arr[2], arr[3])     
    end

    return @graph
  end

  def find_permutations
    @permutations = {}
    @sizes = []
    permutation_loop
    return @permutations.select{|k,v| v == true}.length, @sizes.uniq
  end

  def permutation_loop graph = @graph, ith = 0, cur_x = 1, cur_y = 1, cur_z = 1
    #if cur_x > @max_x || cur_y > @max_y || cur_z > @max_z
      #@permutations[graph] = false
      #p "failed"
      #return false
    #end 

    cur_joint = @graph[ith]

    case cur_joint.dir
    when "x"
      cur_x += cur_joint.length
    when "-x"
      cur_x -= cur_joint.length
    when "y"
      cur_y += cur_joint.length
    when "-y"
      cur_y -= cur_joint.length
    when "z"
      cur_z += cur_joint.length
    when "-z"
      cur_z -= cur_joint.length
    end
    p "X: #{cur_x}, Y: #{cur_y}, Z: #{cur_z}"

    if ith+1 >= @graph.size
      @permutations[graph] = true
      @sizes << [cur_x, cur_y, cur_z]
      p "success"
      return true
    end
    
    @graph[ith].joint_dirs.each do |alt|
      #p alt
      opt_graph = graph.deep_dup
      opt_graph[ith+1].dir = alt
      
      permutation_loop opt_graph, ith+1, cur_x, cur_y, cur_z
    end
  end

  def check_depth graph = @graph, ith = 0, cur_x = 1, cur_y = 1, cur_z = 1
    return cur_x, cur_y, cur_z if ith >= @graph.size

    p @graph[ith] 
    cur_joint = @graph[ith]

    case cur_joint.dir
    when "x"
      cur_x += cur_joint.length
    when "-x"
      cur_x -= cur_joint.length
    when "y"
      cur_y += cur_joint.length
    when "-y"
      cur_y -= cur_joint.length
    when "z"
      cur_z += cur_joint.length
    when "-z"
      cur_z -= cur_joint.length
    end

    ith += 1
    check_depth @graph, ith, cur_x, cur_y, cur_z

    #@graph[ith].joint_dirs.each do |alt|
      #p alt
    #end
  end
end


require "pp"
require "benchmark"

data = []
File.open("data/block_puzzle_1.txt").each_line do |line|
  vertex = line.strip.split(",")
  vertex[0] = vertex[0].to_i
  vertex[1] = vertex[1].strip
  vertex[2] = vertex[2].strip
  vertex[3] = vertex[3].split(" ")

  data << vertex
end

graph1 = Graph.new data
pp graph1
#p graph1.check_depth
p graph1.find_permutations
